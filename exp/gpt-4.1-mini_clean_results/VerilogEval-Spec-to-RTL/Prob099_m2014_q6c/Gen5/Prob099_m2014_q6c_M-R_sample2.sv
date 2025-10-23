module TopModule (
    input  [5:0] y,    // Current one-hot state: y[0]=A, ..., y[5]=F
    input        w,
    output       Y2,   // Next state bit for B (y[1])
    output       Y4    // Next state bit for D (y[3])
);

wire from_A_to_B;
wire from_any_to_D;

// B (y[1]) next state active only if current state is A (y[0]) and w=0
assign from_A_to_B = y[0] & ~w;

// D (y[3]) next state active if input w=1 and current state is one of B, C, D, E, or F (y[1] to y[5])
assign from_any_to_D = w & (|y[5:1]); 

// Output assignments
assign Y2 = from_A_to_B;
assign Y4 = from_any_to_D;

endmodule