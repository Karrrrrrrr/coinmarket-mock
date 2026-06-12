package main

import (
	"math/rand/v2"
	"time"

	"github.com/gin-gonic/gin"
)

type Response struct {
	Data   Data   `json:"data"`
	Status Status `json:"status"`
}

type Data struct {
	Id     int    `json:"id"`
	Symbol string `json:"symbol"`
	Name   string `json:"name"`
	Amount int    `json:"amount"`
	Quote  Quote  `json:"quote"`
}
type Status struct {
	Timestamp    time.Time `json:"timestamp"`
	ErrorCode    int       `json:"error_code"`
	ErrorMessage any       `json:"error_message"`
	Elapsed      int       `json:"elapsed"`
	CreditCount  int       `json:"credit_count"`
	Notice       any       `json:"notice"`
}

type Quote struct {
	USD         USD       `json:"USD"`
	LastUpdated time.Time `json:"last_updated"`
}
type USD struct {
	Price       float64   `json:"price"`
	LastUpdated time.Time `json:"last_updated"`
}

func main() {

	app := gin.Default()

	app.GET("/v2/tools/price-conversion", func(c *gin.Context) {
		var response = Response{
			Data: Data{
				Id:     825,
				Symbol: "USDT",
				Name:   "Tether USDt",
				Amount: 1,
				Quote: Quote{
					USD: USD{
						Price:       1 - rand.Float64()/10, // 介于(0.9-1]之间
						LastUpdated: time.Now(),
					},
					LastUpdated: time.Now(),
				},
			},
			Status: Status{
				Timestamp:    time.Now(),
				ErrorCode:    0,
				ErrorMessage: nil,
				Elapsed:      3,
				CreditCount:  1,
				Notice:       nil,
			},
		}
		c.JSON(200, &response)
	})
	app.Run(":18000")
}
