module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    always @(state, in) begin
        case (1'b1)
            state[0] & ~in: next_state[0] = 1'b1; // S0 --0--> S0
            state[0] & in:  next_state[1] = 1'b1; // S0 --1--> S1
            state[1] & ~in: next_state[0] = 1'b1; // S1 --0--> S0
            state[1] & in:  next_state[2] = 1'b1; // S1 --1--> S2
            state[2] & ~in: next_state[0] = 1'b1; // S2 --0--> S0
            state[2] & in:  next_state[3] = 1'b1; // S2 --1--> S3
            state[3] & ~in: next_state[0] = 1'b1; // S3 --0--> S0
            state[3] & in:  next_state[4] = 1'b1; // S3 --1--> S4
            state[4] & ~in: next_state[0] = 1'b1; // S4 --0--> S0
            state[4] & in:  next_state[5] = 1'b1; // S4 --1--> S5
            state[5] & ~in: next_state[8] = 1'b1; // S5 --0--> S8
            state[5] & in:  next_state[6] = 1'b1; // S5 --1--> S6
            state[6] & ~in: next_state[9] = 1'b1; // S6 --0--> S9
            state[6] & in:  next_state[7] = 1'b1; // S6 --1--> S7
            state[7] & ~in: next_state[0] = 1'b1; // S7 --0--> S0
            state[7] & in:  next_state[7] = 1'b1; // S7 --1--> S7
            state[8] & ~in: next_state[0] = 1'b1; // S8 --0--> S0
            state[8] & in:  next_state[1] = 1'b1; // S8 --1--> S1
            state[9] & ~in: next_state[0] = 1'b1; // S9 --0--> S0
            state[9] & in:  next_state[1] = 1'b1; // S9 --1--> S1
        endcase

        // output logic
        if (state[7]) begin
            out1 = 1'b0;
            out2 = 1'b1;
        end else if (state[8]) begin
            out1 = 1'b1;
            out2 = 1'b0;
        end else if (state[9]) begin
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule