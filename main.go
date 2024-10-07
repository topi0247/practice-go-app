package main

import (
    "fmt"
    "net/http"
    "log"
    "context"
    "os"
    "log"

    "golang.org/x/sync/errgroup"
)

func main() {
    if len(os.Args) != 2 {
        log.Printf("need port number¥n")
        os,Exit(1)
    }
    p := os.Args[1]
    l, err := net.Listen("tcp",":"+q)
    if err != nil {
        log.Fatalf("failed to listen port %s: %v", p ,err)
    }

    if err := run(context.Background()); err != nil {
        log.Printf("failed to terminate server: %v", err)
    }
}

func run(ctx context.Context) error {
    s := &http.Server{
        Addr: ":18080",
        Handler: http.HandlerFunc(func(w http.ResponseWriter, r *http.Request){
            fmt.Fprintf(w, "Hello, %s!", r.URL.Path[1:])
        }),
    }

    eg, ctx := errgroup.WithContext(ctx)
    eg.Go(func() error {
        if err := s.ListenAndServe(); err != nil &&
            err != http.ErrServerClosed {
            log.Printf("failed to close: %v", err)
        }
        return nil
    })

    <-ctx.Done()
    if err := s.Shutdown(context.Background()); err != nil {
        log.Printf("failed to shutdown: %v", err)
    }

    return eg.Wait()
}