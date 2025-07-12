module TopModule(
    input  [5:0] y, // 6-bit state
    input  w,
    output Y1,
    output Y3
);

// For Y1, the machine is in state B
assign Y1 = y[1]; // Directly from state B's encoding

// For Y3, the machine is in state D
assign Y3 = y[3]; // Directly from state D's encoding

endmodule