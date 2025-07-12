module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Current states based on one-hot encoding
    wire state_A = y[0];
    wire state_B = y[1];
    wire state_C = y[2];
    wire state_D = y[3];
    wire state_E = y[4];
    wire state_F = y[5];

    // Y1: next input for flip-flop y[1] (state B)
    // B is entered from A when w=1
    assign Y1 = state_A & w;

    // Y3: next input for flip-flop y[3] (state D)
    // D is entered from B, C, E, F when w=0
    assign Y3 = (~w) & (state_B | state_C | state_E | state_F);

endmodule