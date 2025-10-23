module TopModule(
    input  in1,
    input  in2,
    output out
);

// Explicitly using the bitwise NOT operator to invert in2
wire in2_inv = ~in2;

// Then using the logical AND operator
assign out = in1 & in2_inv;

endmodule