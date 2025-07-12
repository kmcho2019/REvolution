module TopModule (
    input  [5:0] y,  // one-hot current state: y[0]=A ... y[5]=F
    input        w,
    output       Y1, // next-state signal for B (y[1])
    output       Y3  // next-state signal for D (y[3])
);

// Next state B (Y1) from A with w=0
wire from_A_to_B = y[0] & ~w;

// Next state D (Y3) from B, C, D, E, F with w=1
wire from_B_to_D = y[1] & w;
wire from_C_to_D = y[2] & w;
wire from_D_to_D = y[3] & w;
wire from_E_to_D = y[4] & w;
wire from_F_to_D = y[5] & w;

assign Y1 = from_A_to_B;
assign Y3 = from_B_to_D | from_C_to_D | from_D_to_D | from_E_to_D | from_F_to_D;

endmodule