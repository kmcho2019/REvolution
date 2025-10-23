// Simplified NextStateLogic module
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

    // Directly use the input states to simplify logic
    assign B3_next = (B2); // Since B2 always goes to B3 regardless of d
    assign S_next = (S && ~d) || (S1 && ~d) || (S110 && ~d) || (Wait && ack);
    assign S1_next = (S && d);
    assign Count_next = (B3) || (Count && ~done_counting);
    assign Wait_next = (Count && done_counting) || (Wait && ~ack);

endmodule

// Simplified OutputLogic module
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

    // Simplified output logic
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule

// TopModule remains largely the same
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

    // Instantiate the StateDecoder, NextStateLogic, and OutputLogic modules
    StateDecoder state_decoder (.state(state), .S(S), .S1(S1), .S11(S11), .S110(S110), .B0(B0), .B1(B1), .B2(B2), .B3(B3), .Count(Count), .Wait(Wait));

    NextStateLogic next_state_logic (.d(d), .done_counting(done_counting), .ack(ack), .S(S), .S1(S1), .S11(S11), .S110(S110), .B0(B0), .B1(B1), .B2(B2), .B3(B3), .Count(Count), .Wait(Wait), .B3_next(B3_next), .S_next(S_next), .S1_next(S1_next), .Count_next(Count_next), .Wait_next(Wait_next));

    OutputLogic output_logic (.S(S), .S1(S1), .S11(S11), .S110(S110), .B0(B0), .B1(B1), .B2(B2), .B3(B3), .Count(Count), .Wait(Wait), .done(done), .counting(counting), .shift_ena(shift_ena));

endmodule