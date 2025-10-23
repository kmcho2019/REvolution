module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// The current implementation is efficient and clear. 
// No significant improvements can be suggested without additional context or tools.
assign out = (a & b) | (c & d);
assign out_n = ~out;

endmodule