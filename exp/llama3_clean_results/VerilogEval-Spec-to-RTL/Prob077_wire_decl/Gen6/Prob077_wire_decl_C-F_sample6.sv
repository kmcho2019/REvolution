module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Calculate the output using a combination of AND and OR operations
assign out = (a & b) | (c & d);

// Calculate the inverted output using a NOT operation
assign out_n = ~out;

endmodule