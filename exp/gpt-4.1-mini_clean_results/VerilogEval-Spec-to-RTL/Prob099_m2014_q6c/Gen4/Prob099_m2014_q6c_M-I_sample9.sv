module TopModule (
    input  [5:0] y,   // One-hot current state vector: y[0]=A, ..., y[5]=F
    input        w,
    output       Y1,  // Next state bit for B (y[1])
    output       Y3   // Next state bit for D (y[3])
);

// From the FSM transitions, write Boolean expressions for next B (y[1]) and next D (y[3]) states:

// Next state B (y[1]) is reached only from A(y[0]) when w=0
wire next_B = y[0] & ~w;

// Next state D (y[3]) is reached from multiple states on w=1:
// From B(y[1]), C(y[2]), D(y[3]), E(y[4]), F(y[5]) on w=1
// Also from C(y[2]) and E(y[4]) on w=1
wire next_D = (y[1] | y[2] | y[3] | y[4] | y[5]) & w;

// Assign outputs
assign Y1 = next_B;
assign Y3 = next_D;

endmodule