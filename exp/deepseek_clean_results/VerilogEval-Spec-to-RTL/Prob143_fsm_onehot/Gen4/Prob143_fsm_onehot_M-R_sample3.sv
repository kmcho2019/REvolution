module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Temporary signals for common conditions
    wire reset_condition = ~in;
    wire advance_condition = in;
    wire s0_or_s8_or_s9 = state[0] | state[8] | state[9];
    wire s7_or_s9 = state[7] | state[9];
    wire s8_or_s9 = state[8] | state[9];

    // Next state logic using generate for systematic handling
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : state_transitions
            case (i)
                0: assign next_state[i] = reset_condition & (|state[4:0] | s7_or_s9 | state[8] | state[9]);
                1: assign next_state[i] = advance_condition & s0_or_s8_or_s9;
                2: assign next_state[i] = advance_condition & state[1];
                3: assign next_state[i] = advance_condition & state[2];
                4: assign next_state[i] = advance_condition & state[3];
                5: assign next_state[i] = advance_condition & state[4];
                6: assign next_state[i] = advance_condition & state[5];
                7: assign next_state[i] = advance_condition & (state[6] | state[7]);
                8: assign next_state[i] = reset_condition & state[5];
                9: assign next_state[i] = reset_condition & state[6];
                default: assign next_state[i] = 1'b0;
            endcase
        end
    endgenerate

    // Output logic
    assign out1 = |s8_or_s9;
    assign out2 = |s7_or_s9;

endmodule