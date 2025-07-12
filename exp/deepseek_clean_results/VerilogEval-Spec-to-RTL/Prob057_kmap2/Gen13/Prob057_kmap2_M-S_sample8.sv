module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1 = b & ~c;
wire term2 = ~a & c & d;

assign out = ~(term1 | term2);

endmodule