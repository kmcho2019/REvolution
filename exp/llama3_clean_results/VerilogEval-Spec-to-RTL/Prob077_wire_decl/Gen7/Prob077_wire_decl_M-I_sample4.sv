module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Direct implementation of the required logic
assign out = (a & b) | (c & d);
// Inverted output
assign out_n = ~out;

endmodule