module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state
    wire S     = state[0];
    wire S1    = state[1];
    wire S11   = state[2];
    wire S110  = state[3];
    wire B0    = state[4];
    wire B1    = state[5];
    wire B2    = state[6];
    wire B3    = state[7];
    wire Count = state[8];
    wire Wait  = state[9];

    // Instantiate sub-modules
    Controller controller_inst (
        .d(d),
        .done_counting(done_counting),
        .ack(ack),
        .S(S),
        .S1(S1),
        .S11(S11),
        .S110(S110),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .Count(Count),
        .Wait(Wait),
        .B3_next(B3_next),
        .S_next(S_next),
        .S1_next(S1_next),
        .Count_next(Count_next),
        .Wait_next(Wait_next)
    );

    ShiftEnaGenerator shift_ena_generator_inst (
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .shift_ena(shift_ena)
    );

    CountingGenerator counting_generator_inst (
        .Count(Count),
        .counting(counting)
    );

    DoneGenerator done_generator_inst (
        .Wait(Wait),
        .done(done)
    );

endmodule

module Controller (
    input  d,
    input  done_counting,
    input  ack,
    input  S,
    input  S1,
    input  S11,
    input  S110,
    input  B0,
    input  B1,
    input  B2,
    input  B3,
    input  Count,
    input  Wait,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next
);

    assign B3_next = (B2 && d) || (B2 && ~d); // B2 always goes to B3
    assign S_next = (S && ~d) || (S1 && ~d) || (S110 && ~d) || (Wait && ack);
    assign S1_next = (S && d);
    assign Count_next = (B3) || (Count && ~done_counting);
    assign Wait_next = (Count && done_counting) || (Wait && ~ack);

endmodule

module ShiftEnaGenerator (
    input  B0,
    input  B1,
    input  B2,
    input  B3,
    output shift_ena
);

    assign shift_ena = B0 || B1 || B2 || B3;

endmodule

module CountingGenerator (
    input  Count,
    output counting
);

    assign counting = Count;

endmodule

module DoneGenerator (
    input  Wait,
    output done
);

    assign done = Wait;

endmodule