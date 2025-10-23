module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // Next-state bit corresponding to B (y[1])
    output       Y3   // Next-state bit corresponding to D (y[3])
);

// Intermediate wires for next state conditions
wire next_B; // next state B (y[1])
wire next_D; // next state D (y[3])

assign next_B = y[0] & ~w;                      // From A with input w=0
assign next_D = w & (y[1] | y[2] | y[3] | y[4] | y[5]); // From B-F with w=1

assign Y1 = next_B;
assign Y3 = next_D;

endmodule