module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire term1 = (~c & ~d & (~a | ~b)); // group covering (00, 00), (00, 01), (00, 10), (01, 00)
wire term2 = (~c & d  & ~b);         // group covering (01, 10) and (01, 00)
wire term3 = (c  & ~d & ~a);         // group covering (10, 00) and (11, 00)
wire term4 = (c  & d  & (a | b));    // group covering (11, 01), (11, 11), (11, 10)

assign out = term1 | term2 | term3 | term4;

endmodule