module NextStateDecoder(
    input  [5:0] y,
    input        w,
    output [5:0] next_y_in
);
    // State encoding:
    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // Next state inputs derived from the FSM:

    // Next_A: From D on w=0: D (y[3]) & ~w
    assign next_y_in[0] = y[3] & (~w);

    // Next_B: From A on w=1: A (y[0]) & w
    assign next_y_in[1] = y[0] & w;

    // Next_C: From B on w=1 and F on w=1: (B (y[1]) & w) | (F (y[5]) & w)
    assign next_y_in[2] = (y[1] & w) | (y[5] & w);

    // Next_D: From B on w=0, C on w=0, E on w=0, F on w=0: (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w)
    assign next_y_in[3] = (y[1] & (~w)) | (y[2] & (~w)) | (y[4] & (~w)) | (y[5] & (~w));

    // Next_E: From C on w=1 and E on w=1: (y[2] & w) | (y[4] & w)
    assign next_y_in[4] = (y[2] & w) | (y[4] & w);

    // Next_F: From D on w=1: D (y[3]) & w
    assign next_y_in[5] = y[3] & w;

endmodule


module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire [5:0] next_y_in;

    NextStateDecoder nsd (
        .y(y),
        .w(w),
        .next_y_in(next_y_in)
    );

    // Y1 is the input to flip-flop y[1] (B)
    assign Y1 = next_y_in[1];

    // Y3 is the input to flip-flop y[3] (D)
    assign Y3 = next_y_in[3];

endmodule