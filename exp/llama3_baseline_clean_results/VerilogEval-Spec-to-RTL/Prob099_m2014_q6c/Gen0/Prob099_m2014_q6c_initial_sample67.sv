module TopModule(
    input [5:0] y,  // Current state
    input w,       // Input signal
    output Y1,     // Next state signal for A
    output Y3      // Next state signal for C
);

// Assign Y1 and Y3 based on the current state and input w
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w);  // A and w=0
assign Y3 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]);  // C

endmodule