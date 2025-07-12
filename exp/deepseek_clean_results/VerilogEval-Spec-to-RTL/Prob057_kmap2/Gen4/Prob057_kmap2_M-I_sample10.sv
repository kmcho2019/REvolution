module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1, term2, term3, term4;

// Optimized logic implementation
assign term1 = ~a & (~b | ~d);
assign term2 = ~c;
assign term3 = b & ~c & ~d;
assign term4 = a & ~b & ~c;

assign out = term1 | term2 | term3 | term4;

endmodule