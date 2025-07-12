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

    wire [9:0] next_state;

    StateTransition state_transition_inst (
        .d(d),
        .done_counting(done_counting),
        .ack(ack),
        .state(state),
        .next_state(next_state)
    );

    OutputLogic output_logic_inst (
        .state(state),
        .next_state(next_state),
        .B3_next(B3_next),
        .S_next(S_next),
        .S1_next(S1_next),
        .Count_next(Count_next),
        .Wait_next(Wait_next),
        .done(done),
        .counting(counting),
        .shift_ena(shift_ena)
    );

endmodule

module StateTransition (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output [9:0] next_state
);

    // Implement next-state logic here based on the state machine's description
    always @(*) begin
        case (1'b1)
            state[0]: next_state = (d) ? 10'b0000000010 : 10'b0000000001;
            state[1]: next_state = (d) ? 10'b0000000100 : 10'b0000000001;
            state[2]: next_state = (d) ? 10'b0000000100 : 10'b0000001000;
            state[3]: next_state = (d) ? 10'b0000001000 : 10'b0000000001;
            state[4]: next_state = 10'b0000000100; // B0 always goes to B1
            state[5]: next_state = 10'b0000001000; // B1 always goes to B2
            state[6]: next_state = 10'b0010000000; // B2 always goes to B3
            state[7]: next_state = (done_counting) ? 10'b0100000000 : 10'b0010000000; // Count
            state[8]: next_state = (ack) ? 10'b0000000001 : 10'b0100000000; // Wait
            default: next_state = 10'b0000000001; // Default to state S
        endcase
    end

endmodule

module OutputLogic (
    input  [9:0] state,
    input  [9:0] next_state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    assign B3_next = next_state[6];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[7];
    assign Wait_next = next_state[8];

    assign done = state[9];
    assign counting = state[7];
    assign shift_ena = state[4] || state[5] || state[6] || state[7];

endmodule