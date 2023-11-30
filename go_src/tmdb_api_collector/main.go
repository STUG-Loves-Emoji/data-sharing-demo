package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"

	"github.com/ryanbradynd05/go-tmdb"
)

type JsonData struct {
	MovieNames []string `json:"movies"`
}

func main() {

	// var tmdbAPI *tmdb.TMDb
	tmdbAPI := tmdb.Init(tmdb.Config{
		APIKey: "XXXXXX",
	})

	jsonFile, err := os.Open("movie-list.json")
	if err != nil {
		fmt.Println("Error:", err)
	}
	defer jsonFile.Close()
	byteValue, _ := io.ReadAll(jsonFile)
	var myData JsonData

	_ = json.Unmarshal(byteValue, &myData)

	for i := 0; i < len(myData.MovieNames); i++ {

		res, err := tmdbAPI.SearchMovie(myData.MovieNames[i], nil)
		if err != nil {
			fmt.Println(err)
		}

		jData, _ := tmdb.ToJSON(res)
		fmt.Println(jData, ",")
	}
}
