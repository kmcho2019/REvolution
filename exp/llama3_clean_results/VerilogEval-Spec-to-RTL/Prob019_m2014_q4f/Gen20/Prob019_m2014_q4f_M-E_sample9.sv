module TopModule(
    input in1,
    input in2,
    output out
);

// Invert in1
wire in1_inv;
assign in1_inv = ~in1;

// Use in2 as select line for the MUX
assign out = in2? in1_inv : in1;

endmodule