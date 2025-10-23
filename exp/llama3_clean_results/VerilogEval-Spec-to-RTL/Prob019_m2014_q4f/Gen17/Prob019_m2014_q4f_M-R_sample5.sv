module TopModule(
    input in1,
    input in2,
    output out
);

// Refactored implementation using assign
assign out = in1 & ~in2;

endmodule