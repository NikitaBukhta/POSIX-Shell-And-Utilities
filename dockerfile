FROM gcc:latest

COPY . .

RUN gcc -o main main.c

CMD [ "./main", "./magic.sh" ]