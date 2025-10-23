module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Assign statement to implement the OR operation of two AND gates
assign out = (a & b) | (c & d);

// Invert the output 'out' to produce 'out_n'
assign out_n = ~out;

endmodule