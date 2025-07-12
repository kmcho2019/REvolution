module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire not_a = ~a;
wire not_b = ~b;
wire not_c = ~c;
wire not_d = ~d;

assign out = 
      (not_c & not_d & (not_a | not_b)) // covers cd=00 and ab=00,01,10 with output=1
    | (not_c &  d & not_b)             // cd=01 and ab=00,10 with output=1
    | ( c & not_d & not_a)             // cd=10 and ab=00,01 with output=1
    | ( c &  d & (a | b));             // cd=11 and ab=01,10,11 with output=1

endmodule