module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1 = ~a | ~c;
wire term2 = ~b | ~d;
wire term3 = a ^ b;

assign out = term1 | term2 | term3;

endmodule