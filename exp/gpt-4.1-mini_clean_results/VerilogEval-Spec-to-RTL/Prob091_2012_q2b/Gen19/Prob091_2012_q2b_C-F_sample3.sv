module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Inverted signals for reuse and lower power
    wire w_n = ~w;
    wire y0_n = ~y[0];
    wire y3_n = ~y[3];

    // Next state input for y[1] (state B)
    assign Y1 = y[0] & w;

    // Next state input for y[3] (state D)
    // Using AND of inverted signals to implement NOR(w, y[0], y[3]) for low power/glitches
    assign Y3 = w_n & y0_n & y3_n;
endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    NextStateInput next_state_inst(
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );
endmodule