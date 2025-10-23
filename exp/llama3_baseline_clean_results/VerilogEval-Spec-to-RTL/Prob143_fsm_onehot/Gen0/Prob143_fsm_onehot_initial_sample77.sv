module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = 10'b0; // initialize next_state with zeros

    // implement next state logic
    always @(*) begin
        case (1'b1) // one-hot encoding, so at least one bit should be 1
            state[9]: next_state[1] = in, next_state[0] = ~in; // S9
            state[8]: next_state[1] = in, next_state[0] = ~in; // S8
            state[7]: next_state[7] = in, next_state[0] = ~in; // S7
            state[6]: next_state[9] = ~in, next_state[1] = in; // S6
            state[5]: next_state[8] = ~in, next_state[1] = in; // S5
            state[4]: next_state[5] = in, next_state[0] = ~in; // S4
            state[3]: next_state[4] = in, next_state[0] = ~in; // S3
            state[2]: next_state[3] = in, next_state[0] = ~in; // S2
            state[1]: next_state[2] = in, next_state[0] = ~in; // S1
            state[0]: next_state[1] = in, next_state[0] = ~in; // S0
            default: next_state[0] = 1'b1; // default to S0 if no state is set
        endcase
    end

    // implement output logic
    always @(*) begin
        out1 = state[7] | state[9]; // S7 and S9 have out1 = 1
        out2 = state[7] | state[8] | state[9]; // S7, S8, and S9 have out2 = 1
    end

endmodule