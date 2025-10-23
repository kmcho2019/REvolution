module TopModule(
    input [5:0] y, // 6-bit input for current state
    input w,      // input for determining next state
    output Y1,    // next-state signal for y[1]
    output Y3     // next-state signal for y[3]
);

// Logic equation for next-state signal Y1
assign Y1 = (y[0] & w) | (y[3] & w);

// Logic equation for next-state signal Y3
assign Y3 = (y[1] & w) | (y[2] & w) | (y[3] & ~w) | (y[4] & ~w);

endmodule