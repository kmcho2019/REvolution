module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y2,  // Next state bit for B (y[1])
    output       Y4   // Next state bit for D (y[3])
);

// Y2 is high only when current state is A (y[0]) and w=0
assign Y2 = y[0] & ~w;

// Y4 is high when the next state is D:
// From B(1), C(2), D(3), E(4), F(5) on w=1
assign Y4 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule