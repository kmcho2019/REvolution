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

    // Sub-modules for each phase
    wire shifting_phase_output;
    wire input_processing_phase_output;
    wire counting_phase_output;

    // Shifting Phase Module
    module ShiftingPhase (
        input  [9:0] state,
        output B3_next,
        output shift_ena
    );
        assign B3_next = (state[6] && d) || (state[6] && ~d); // B2 always goes to B3
        assign shift_ena = state[4] || state[5] || state[6] || state[7];
    endmodule

    // Input Processing Phase Module
    module InputProcessingPhase (
        input  d,
        input  [9:0] state,
        output S_next,
        output S1_next
    );
        assign S_next = (state[0] && ~d) || (state[1] && ~d) || (state[3] && ~d);
        assign S1_next = (state[0] && d);
    endmodule

    // Counting Phase Module
    module CountingPhase (
        input  done_counting,
        input  ack,
        input  [9:0] state,
        output Count_next,
        output Wait_next,
        output done,
        output counting
    );
        assign Count_next = (state[7]) || (state[8] && ~done_counting);
        assign Wait_next = (state[8] && done_counting) || (state[9] && ~ack);
        assign done = state[9];
        assign counting = state[8];
    endmodule

    // Instantiating the sub-modules
    ShiftingPhase shifting_phase (.state(state),.B3_next(B3_next),.shift_ena(shift_ena));
    InputProcessingPhase input_processing_phase (.d(d),.state(state),.S_next(S_next),.S1_next(S1_next));
    CountingPhase counting_phase (.done_counting(done_counting),.ack(ack),.state(state),.Count_next(Count_next),.Wait_next(Wait_next),.done(done),.counting(counting));

endmodule