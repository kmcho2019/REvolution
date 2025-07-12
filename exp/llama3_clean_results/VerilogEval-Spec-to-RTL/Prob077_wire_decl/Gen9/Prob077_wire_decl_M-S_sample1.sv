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

// Use an assign statement to implement the NOT gate for 'out_n'
assign out_n = ~out;

endmodule