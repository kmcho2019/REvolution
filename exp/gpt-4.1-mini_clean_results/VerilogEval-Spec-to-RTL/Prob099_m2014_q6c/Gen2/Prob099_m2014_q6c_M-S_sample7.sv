module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y1,  // Next state bit for B (y[1])
    output       Y3   // Next state bit for D (y[3])
);

// Y1 is high only when current state is A (y[0]) and w=0
assign Y1 = y[0] & ~w;

// Y3 is high when the next state is D:
// From B(1), C(2), D(3), E(4), F(5) on w=1
assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule