module TopModule(
    input [5:0] y,  // One-hot encoded state
    input w,
    output Y1,     // Output corresponding to state B (y[1])
    output Y3       // Output corresponding to state D (y[3])
);

// One-hot encoded states
wire A = y[0];  // State A
wire B = y[1];  // State B
wire C = y[2];  // State C
wire D = y[3];  // State D
wire E = y[4];  // State E
wire F = y[5];  // State F

// Next-state logic for Y1 (state B)
assign Y1 = (~w & A) | (~w & F);

// Next-state logic for Y3 (state D)
assign Y3 = (w & B) | (w & C) | (w & E) | (w & D) | (w & F);

endmodule