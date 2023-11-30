package main

import (
	"context"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io"
	"math/rand"
	"os"

	kafka "github.com/segmentio/kafka-go"
)

type DataArray struct {
	Emojis []JsonData `json:"emojis"`
}

type JsonData struct {
	Type  string `json:"type"`
	Emoji string `json:"emoji"`
	Value string `json:"value"`
}

func newKafkaWriter(kafkaURL, topic string) *kafka.Writer {
	cert, err := tls.LoadX509KeyPair("client.crt", "client.key")
	if err != nil {
		fmt.Println(err)
		os.Exit(0)
	}

	return &kafka.Writer{
		Addr:     kafka.TCP(kafkaURL),
		Topic:    topic,
		Balancer: &kafka.LeastBytes{},
		Transport: &kafka.Transport{
			TLS: &tls.Config{
				InsecureSkipVerify: true,
				Certificates:       []tls.Certificate{cert},
			},
		},
	}
}

func PostEmoji(writer *kafka.Writer, emoji JsonData) {
	jString, _ := json.Marshal(emoji)
	msg := kafka.Message{
		Key:   []byte(emoji.Value),
		Value: jString,
	}

	err := writer.WriteMessages(context.Background(), msg)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Posted Message: ", emoji.Value)
	}
}

func main() {
	// get kafka writer using environment variables.
	kafkaURL := os.Getenv("kafkaURL")
	topic := os.Getenv("topic")
	writer := newKafkaWriter(kafkaURL, topic)
	defer writer.Close()
	fmt.Println("start producing ... !!")

	jsonFile, err := os.Open("movies.json")
	if err != nil {
		fmt.Println("Error:", err)
	}
	defer jsonFile.Close()

	byteValue, _ := io.ReadAll(jsonFile)
	var emojiData DataArray

	_ = json.Unmarshal(byteValue, &emojiData)

	arrayLen := len(emojiData.Emojis)

	for i := 0; i < 2000; i++ {
		PostEmoji(writer, emojiData.Emojis[rand.Intn(arrayLen)])
	}
}
