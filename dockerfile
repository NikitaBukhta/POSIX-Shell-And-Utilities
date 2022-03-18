FROM gcc:latest

COPY . .

RUN gcc -o main src/main.c

CMD [ "./main", "./magic.sh" ]