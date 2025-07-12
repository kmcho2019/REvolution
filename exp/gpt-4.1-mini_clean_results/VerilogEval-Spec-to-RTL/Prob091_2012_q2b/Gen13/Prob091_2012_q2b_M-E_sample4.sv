module StateDecoder(
    input  [5:0] y,
    output       A,
    output       B,
    output       C,
    output       D,
    output       E,
    output       F
);
    // One-hot decoding
    assign A = y[0];
    assign B = y[1];
    assign C = y[2];
    assign D = y[3];
    assign E = y[4];
    assign F = y[5];
endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire A, B, C, D, E, F;

    // Decode one-hot states
    StateDecoder decoder(
        .y(y),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F)
    );

    wire w_n = ~w;

    // Y1 input: next input for y[1] (state B)
    // According to FSM: From A with w=1 -> B
    assign Y1 = w & A;

    // Y3 input: next input for y[3] (state D)
    // From B,C,D,E,F with w=0 -> D
    assign Y3 = w_n & (B | C | D | E | F);
endmodule