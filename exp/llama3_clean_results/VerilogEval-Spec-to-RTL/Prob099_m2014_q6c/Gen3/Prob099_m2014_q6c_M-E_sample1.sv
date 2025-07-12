module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

// Conditions for next-state signals Y2 and Y4
wire cond_Y2_A_to_B = y[0] & w;
wire cond_Y2_D_to_B = y[3] & ~w;
wire cond_Y2_F_to_B = y[5] & ~w;

wire cond_Y4_B_to_D = y[1] & ~w;
wire cond_Y4_C_to_D = y[2] & ~w;
wire cond_Y4_E_to_D = y[4] & w;

// Logic equations for Y2 and Y4
assign Y2 = cond_Y2_A_to_B | cond_Y2_D_to_B | cond_Y2_F_to_B;
assign Y4 = cond_Y4_B_to_D | cond_Y4_C_to_D | cond_Y4_E_to_D;

endmodule