module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire term1; // c & a
wire term2; // ~c & ~d & a
wire term3; // c & ~a & ~b

assign term1 = c & a;
assign term2 = (~c) & (~d) & a;
assign term3 = c & (~a) & (~b);

assign out = term1 | term2 | term3;

endmodule