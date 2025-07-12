module TopModule(
    input in1,
    input in2,
    output out
);

// Simplified implementation using assign statement
assign out = in1 & ~in2;

endmodule