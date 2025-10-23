module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// One-hot encoded states
wire is_A = y[0];  // 000001
wire is_B = y[1];  // 000010
wire is_C = y[2];  // 000100
wire is_D = y[3];  // 001000
wire is_E = y[4];  // 010000
wire is_F = y[5];  // 100000

// Logic for Y1 (input to state flip-flop y[1], state B)
assign Y1 = is_A & w;

// Logic for Y3 (input to state flip-flop y[3], state D)
assign Y3 = (~w) & (is_B | is_C | is_E | is_F);

endmodule