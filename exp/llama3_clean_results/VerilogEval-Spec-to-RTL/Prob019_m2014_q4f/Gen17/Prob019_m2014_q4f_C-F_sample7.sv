module TopModule(
    input  in1,
    input  in2,
    output out
);

// Explicitly model the inversion of in2 for clarity
wire not_in2 = ~in2;

// Use a continuous assignment for the AND operation with the inverted in2
assign out = in1 & not_in2;

endmodule