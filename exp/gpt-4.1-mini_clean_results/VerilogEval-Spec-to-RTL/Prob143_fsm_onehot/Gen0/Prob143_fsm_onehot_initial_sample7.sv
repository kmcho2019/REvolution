module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Declare next state signals
    reg [9:0] next_state_reg;
    reg       out1_reg, out2_reg;

    integer i;

    always @* begin
        // Initialize next_state and outputs to zero
        next_state_reg = 10'b0;
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        // For each active current state, update next_state and outputs accordingly
        // S0 = state[0]
        if (state[0]) begin
            if (in == 1'b0) next_state_reg[0] = 1'b1; // S0 --0--> S0
            else            next_state_reg[1] = 1'b1; // S0 --1--> S1
            // outputs (0,0)
        end

        // S1 = state[1]
        if (state[1]) begin
            if (in == 1'b0) next_state_reg[0] = 1'b1; // S1 --0--> S0
            else            next_state_reg[2] = 1'b1; // S1 --1--> S2
            // outputs (0,0)
        end

        // S2 = state[2]
        if (state[2]) begin
            if (in == 1'b0) next_state_reg[0] = 1'b1; // S2 --0--> S0
            else            next_state_reg[3] = 1'b1; // S2 --1--> S3
            // outputs (0,0)
        end

        // S3 = state[3]
        if (state[3]) begin
            if (in == 1'b0) next_state_reg[0] = 1'b1; // S3 --0--> S0
            else            next_state_reg[4] = 1'b1; // S3 --1--> S4
            // outputs (0,0)
        end

        // S4 = state[4]
        if (state[4]) begin
            if (in == 1'b0) next_state_reg[0] = 1'b1; // S4 --0--> S0
            else            next_state_reg[5] = 1'b1; // S4 --1--> S5
            // outputs (0,0)
        end

        // S5 = state[5]
        if (state[5]) begin
            if (in == 1'b0) next_state_reg[8] = 1'b1; // S5 --0--> S8
            else            next_state_reg[6] = 1'b1; // S5 --1--> S6
            // outputs (0,0)
        end

        // S6 = state[6]
        if (state[6]) begin
            if (in == 1'b0) next_state_reg[9] = 1'b1; // S6 --0--> S9
            else            next_state_reg[7] = 1'b1; // S6 --1--> S7
            // outputs (0,0)
        end

        // S7 = state[7]
        if (state[7]) begin
            if (in == 1'b0) next_state_reg[0] = 1'b1; // S7 --0--> S0
            else            next_state_reg[7] = 1'b1; // S7 --1--> S7
            // outputs (0,1)
            out2_reg = 1'b1;
        end

        // S8 = state[8]
        if (state[8]) begin
            if (in == 1'b0) next_state_reg[0] = 1'b1; // S8 --0--> S0
            else            next_state_reg[1] = 1'b1; // S8 --1--> S1
            // outputs (1,0)
            out1_reg = 1'b1;
        end

        // S9 = state[9]
        if (state[9]) begin
            if (in == 1'b0) next_state_reg[0] = 1'b1; // S9 --0--> S0
            else            next_state_reg[1] = 1'b1; // S9 --1--> S1
            // outputs (1,1)
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule