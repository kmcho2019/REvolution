module TopModule(
    input in1,
    input in2,
    output reg out
);

// Fused implementation using an always block with continuous assignment
always @(*) out = in1 & ~in2;

endmodule