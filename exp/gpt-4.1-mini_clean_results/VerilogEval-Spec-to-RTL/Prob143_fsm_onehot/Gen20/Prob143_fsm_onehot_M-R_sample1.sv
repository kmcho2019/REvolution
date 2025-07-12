module TopModule (
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg       out1,
    output reg       out2
);

    always @(*) begin
        // Default assignments
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        // Next state logic: OR of all possible transitions from active states

        // S0 transitions
        if (state[0]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // S0 --0--> S0
            else             next_state[1] = 1'b1; // S0 --1--> S1
        end

        // S1 transitions
        if (state[1]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // S1 --0--> S0
            else             next_state[2] = 1'b1; // S1 --1--> S2
        end

        // S2 transitions
        if (state[2]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // S2 --0--> S0
            else             next_state[3] = 1'b1; // S2 --1--> S3
        end

        // S3 transitions
        if (state[3]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // S3 --0--> S0
            else             next_state[4] = 1'b1; // S3 --1--> S4
        end

        // S4 transitions
        if (state[4]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // S4 --0--> S0
            else             next_state[5] = 1'b1; // S4 --1--> S5
        end

        // S5 transitions
        if (state[5]) begin
            if (in == 1'b0) next_state[8] = 1'b1; // S5 --0--> S8
            else             next_state[6] = 1'b1; // S5 --1--> S6
        end

        // S6 transitions
        if (state[6]) begin
            if (in == 1'b0) next_state[9] = 1'b1; // S6 --0--> S9
            else             next_state[7] = 1'b1; // S6 --1--> S7
        end

        // S7 transitions
        if (state[7]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // S7 --0--> S0
            else             next_state[7] = 1'b1; // S7 --1--> S7
        end

        // S8 transitions
        if (state[8]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // S8 --0--> S0
            else             next_state[1] = 1'b1; // S8 --1--> S1
        end

        // S9 transitions
        if (state[9]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // S9 --0--> S0
            else             next_state[1] = 1'b1; // S9 --1--> S1
        end

        // Outputs depend on current states, not next states

        out1 = (state[8] || state[9]) ? 1'b1 : 1'b0; // out1 = 1 if S8 or S9
        out2 = (state[7] || state[9]) ? 1'b1 : 1'b0; // out2 = 1 if S7 or S9
    end

endmodule