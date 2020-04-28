package main

import (
	"fmt"
	"github.com/carlosroman/golang-simple-app/internal/pkg/server"
	log "github.com/sirupsen/logrus"
	"github.com/urfave/cli"
	"os"
)

const LOCAL_BUILD_VERSION = "snapshot"

var version = LOCAL_BUILD_VERSION

func main() {
	app := cli.NewApp()
	app.Name = "Webapp"
	app.Version = version
	app.Authors = []cli.Author{
		{
			Name:  "Carlos Roman",
			Email: "carlosr@cliche-corp.co.uk",
		},
	}
	log.SetLevel(log.InfoLevel)
	app.Commands = []cli.Command{
		{Name: "run",
			Aliases: []string{"r"},
			Usage:   "run server",
			Flags: []cli.Flag{
				cli.IntFlag{
					Name:   "port, p",
					Value:  8080,
					Usage:  "Set the port of the server",
					EnvVar: "SERVER_PORT",
				},
			},
			Action: func(c *cli.Context) error {
				addr := fmt.Sprintf("0.0.0.0:%v", c.Int("port"))
				log.Infof("Starting server at %s", addr)
				srv := server.New(addr)
				if err := srv.ListenAndServe(); err != nil {
					return cli.NewExitError(err, 1)
				}
				return nil
			},
		},
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}
