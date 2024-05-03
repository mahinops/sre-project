package cmd

import (
	"log"

	"github.com/mokhlesurr031/sre-project/backend/internal/connection"
	"github.com/mokhlesurr031/sre-project/backend/internal/envs"
	"github.com/spf13/cobra"
)

var serveCmd = &cobra.Command{
	Use:   "serve",
	Short: "Starting Server...",
	Long:  `Starting Server...`,
	Run:   server,
}

func init() {
	rootCmd.AddCommand(serveCmd)
}

func server(cmd *cobra.Command, args []string) {
	log.Println("Running Application")

	// Initialize database connection
	err := connection.InitializeDB(
		envs.DB().Username,
		envs.DB().Password,
		envs.DB().Host,
		envs.DB().Port,
		envs.DB().Name,
	)
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v", err)
	}
}
