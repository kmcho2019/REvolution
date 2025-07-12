module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

    always @(*) begin
        // Initialize next_state to zero
        next_state = 10'b0;

        // Compute next_state bits as the OR of all transitions from states with input conditions
        // next_state[0] <= transitions to S0
        next_state[0] = 
            (state[0] & ~in) | // S0 --0--> S0
            (state[1] & ~in) | // S1 --0--> S0
            (state[2] & ~in) | // S2 --0--> S0
            (state[3] & ~in) | // S3 --0--> S0
            (state[4] & ~in) | // S4 --0--> S0
            (state[7] & ~in) | // S7 --0--> S0
            (state[8] & ~in) | // S8 --0--> S0
            (state[9] & ~in);  // S9 --0--> S0

        // next_state[1] <= transitions to S1
        next_state[1] =
            (state[0] &  in) | // S0 --1--> S1
            (state[9] &  in) | // S9 --1--> S1
            (state[8] &  in);  // S8 --1--> S1

        // next_state[2] <= transitions to S2
        next_state[2] = (state[1] & in); // S1 --1--> S2

        // next_state[3] <= transitions to S3
        next_state[3] = (state[2] & in); // S2 --1--> S3

        // next_state[4] <= transitions to S4
        next_state[4] = (state[3] & in); // S3 --1--> S4

        // next_state[5] <= transitions to S5
        next_state[5] = (state[4] & in); // S4 --1--> S5

        // next_state[6] <= transitions to S6
        next_state[6] = (state[5] & in); // S5 --1--> S6

        // next_state[7] <= transitions to S7
        next_state[7] = (state[6] & in) | (state[7] & in); // S6 --1--> S7, S7 --1--> S7

        // next_state[8] <= transitions to S8
        next_state[8] = (state[5] & ~in); // S5 --0--> S8

        // next_state[9] <= transitions to S9
        next_state[9] = (state[6] & ~in); // S6 --0--> S9
    end

    // Outputs according to the problem statement
    // out1 = 1 if in state S8
    assign out1 = state[8];

    // out2 = 1 if in state S7 or S9
    assign out2 = state[7] | state[9];

endmodule