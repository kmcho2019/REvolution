module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define next state signals
    reg [9:0] next_state_reg;
    reg out1_reg, out2_reg;

    integer i;
    always @(*) begin
        next_state_reg = 10'b0;
        out1_reg = 0;
        out2_reg = 0;

        // For each possible current state, add possible next states
        // States S0 to S9: state[0] to state[9]

        // S0 transitions
        if(state[0]) begin
            // S0 (0,0) --0--> S0
            if(in == 0) next_state_reg[0] = 1'b1;
            // S0 (0,0) --1--> S1
            else         next_state_reg[1] = 1'b1;
            // outputs zero for S0
        end

        // S1 transitions
        if(state[1]) begin
            // S1 (0,0) --0--> S0
            if(in == 0) next_state_reg[0] = 1'b1;
            // S1 (0,0) --1--> S2
            else         next_state_reg[2] = 1'b1;
            // outputs zero
        end

        // S2 transitions
        if(state[2]) begin
            // S2 (0,0) --0--> S0
            if(in == 0) next_state_reg[0] = 1'b1;
            // S2 (0,0) --1--> S3
            else         next_state_reg[3] = 1'b1;
            // outputs zero
        end

        // S3 transitions
        if(state[3]) begin
            // S3 (0,0) --0--> S0
            if(in == 0) next_state_reg[0] = 1'b1;
            // S3 (0,0) --1--> S4
            else         next_state_reg[4] = 1'b1;
            // outputs zero
        end

        // S4 transitions
        if(state[4]) begin
            // S4 (0,0) --0--> S0
            if(in == 0) next_state_reg[0] = 1'b1;
            // S4 (0,0) --1--> S5
            else         next_state_reg[5] = 1'b1;
            // outputs zero
        end

        // S5 transitions
        if(state[5]) begin
            // S5 (0,0) --0--> S8
            if(in == 0) next_state_reg[8] = 1'b1;
            // S5 (0,0) --1--> S6
            else         next_state_reg[6] = 1'b1;
            // outputs zero
        end

        // S6 transitions
        if(state[6]) begin
            // S6 (0,0) --0--> S9
            if(in == 0) next_state_reg[9] = 1'b1;
            // S6 (0,0) --1--> S7
            else         next_state_reg[7] = 1'b1;
            // outputs zero
        end

        // S7 transitions and outputs (0,1)
        if(state[7]) begin
            // S7 (0,1) --0--> S0
            if(in == 0) next_state_reg[0] = 1'b1;
            // S7 (0,1) --1--> S7
            else         next_state_reg[7] = 1'b1;
            // outputs (0,1)
            out1_reg = 0;
            out2_reg = 1;
        end

        // S8 transitions and outputs (1,0)
        if(state[8]) begin
            // S8 (1,0) --0--> S0
            if(in == 0) next_state_reg[0] = 1'b1;
            // S8 (1,0) --1--> S1
            else         next_state_reg[1] = 1'b1;
            // outputs (1,0)
            out1_reg = 1;
            out2_reg = 0;
        end

        // S9 transitions and outputs (1,1)
        if(state[9]) begin
            // S9 (1,1) --0--> S0
            if(in == 0) next_state_reg[0] = 1'b1;
            // S9 (1,1) --1--> S1
            else         next_state_reg[1] = 1'b1;
            // outputs (1,1)
            out1_reg = 1;
            out2_reg = 1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule