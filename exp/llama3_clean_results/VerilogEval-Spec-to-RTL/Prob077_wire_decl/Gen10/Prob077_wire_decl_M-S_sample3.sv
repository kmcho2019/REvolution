module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Directly calculate 'out' by combining the AND and OR operations
assign out = (a & b) | (c & d);

// Directly calculate 'out_n' as the inversion of 'out'
assign out_n = ~(a & b | c & d);

endmodule