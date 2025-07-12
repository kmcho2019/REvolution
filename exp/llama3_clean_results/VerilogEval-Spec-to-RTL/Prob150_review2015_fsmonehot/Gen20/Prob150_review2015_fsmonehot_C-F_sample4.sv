module StateDecoder (
    input  [9:0] state,  // one-hot encoding
    output S,
    output S1,
    output S11,
    output S110,
    output B0,
    output B1,
    output B2,
    output B3,
    output Count,
    output Wait
);

    assign S     = state[0];
    assign S1    = state[1];
    assign S11   = state[2];
    assign S110  = state[3];
    assign B0    = state[4];
    assign B1    = state[5];
    assign B2    = state[6];
    assign B3    = state[7];
    assign Count = state[8];
    assign Wait  = state[9];

endmodule

module NextStateLogic (
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

module OutputLogic (
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
    output done,
    output counting,
    output shift_ena
);

    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule

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

    wire S, S1, S11, S110, B0, B1, B2, B3, Count, Wait;

    StateDecoder state_decoder (.state(state), .S(S), .S1(S1), .S11(S11), .S110(S110), .B0(B0), .B1(B1), .B2(B2), .B3(B3), .Count(Count), .Wait(Wait));

    NextStateLogic next_state_logic (.d(d), .done_counting(done_counting), .ack(ack), .S(S), .S1(S1), .S11(S11), .S110(S110), .B0(B0), .B1(B1), .B2(B2), .B3(B3), .Count(Count), .Wait(Wait), .B3_next(B3_next), .S_next(S_next), .S1_next(S1_next), .Count_next(Count_next), .Wait_next(Wait_next));

    OutputLogic output_logic (.S(S), .S1(S1), .S11(S11), .S110(S110), .B0(B0), .B1(B1), .B2(B2), .B3(B3), .Count(Count), .Wait(Wait), .done(done), .counting(counting), .shift_ena(shift_ena));

endmodule