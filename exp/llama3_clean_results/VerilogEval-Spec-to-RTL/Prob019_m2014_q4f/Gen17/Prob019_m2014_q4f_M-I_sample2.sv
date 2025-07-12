module TopModule(
    input in1,
    input in2,
    output out
);

// Directly assign the output with the AND operation and inverter
assign out = in1 & ~in2;

endmodule