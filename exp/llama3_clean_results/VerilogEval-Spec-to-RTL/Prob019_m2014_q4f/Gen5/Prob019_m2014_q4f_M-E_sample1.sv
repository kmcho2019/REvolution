module TopModule(
    input in1,
    input in2,
    output out
);

// Invert in2
wire inv_in2;
assign inv_in2 = ~in2;

// AND in1 and inverted in2
assign out = in1 & inv_in2;

endmodule