# start with base image
FROM golang:1.22 as base 

# set an working directory inside the container
WORKDIR /app

#copy go.mod files to the working directory
COPY go.mod .

#download all dependencies
RUN go mod download

#copy the source code to the working directory
COPY . .

#build the application
RUN go build -o main .

#if we run cmd here the image size is bigger so we use multi staged docker distroless image
#EXPOSE 8091
#CMD ["./main"]

#reduce the image size using multi-stage builds
# Final stage - we were using a Distroless image to run this application
FROM gcr.io/distroless/base

#copy the binary from the previous stage
COPY --from=base /app/main .

#copy static files from previous stage
COPY --from=base /app/static ./static

#expose the port, which application runs
EXPOSE 8080

#command to run the application
CMD [ "./main" ]