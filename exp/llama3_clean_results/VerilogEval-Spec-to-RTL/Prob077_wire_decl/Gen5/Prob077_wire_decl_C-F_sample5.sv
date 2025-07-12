module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Declare intermediate wires for clarity
wire and_result1, and_result2;

// Assign the AND operations to the intermediate wires
assign and_result1 = a & b;
assign and_result2 = c & d;

// Use the intermediate wires to compute the final output
assign out = and_result1 | and_result2;
assign out_n = ~out; // Directly invert the output for out_n

endmodule