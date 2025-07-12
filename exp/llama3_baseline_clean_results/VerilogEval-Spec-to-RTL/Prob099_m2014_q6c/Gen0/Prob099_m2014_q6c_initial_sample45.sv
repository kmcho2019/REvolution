module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoded states
wire state_A = y[0];
wire state_B = y[1];
wire state_C = y[2];
wire state_D = y[3];
wire state_E = y[4];
wire state_F = y[5];

// Next-state logic for Y2 (state B)
assign Y1 = (~w) & state_A;

// Next-state logic for Y4 (state D)
assign Y3 = (w & (state_B | state_C | state_E | state_F));

endmodule