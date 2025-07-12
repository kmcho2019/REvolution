module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Directly calculate the output to minimize intermediate wires and gates.
assign out = (a & b) | (c & d);

// Use a separate assign statement for out_n to maintain clarity and readability.
assign out_n = ~out;

endmodule