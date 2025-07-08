module TopModule (
    input  wire        in,
    input  wire [9:0]  state,
    output wire [9:0]  next_state,
    output wire        out1,
    output wire        out2
);

    // Initialize all next_state bits to zero
    reg [9:0] next_state_reg;

    always @(*) begin
        next_state_reg = 10'b0;

        // For each state bit, compute next states per input 'in'
        // S0 (state[0])
        if (state[0]) begin
            if (in)
                next_state_reg[1] = 1'b1; // S1
            else
                next_state_reg[0] = 1'b1; // S0
        end

        // S1 (state[1])
        if (state[1]) begin
            if (in)
                next_state_reg[2] = 1'b1; // S2
            else
                next_state_reg[0] = 1'b1; // S0
        end

        // S2 (state[2])
        if (state[2]) begin
            if (in)
                next_state_reg[3] = 1'b1; // S3
            else
                next_state_reg[0] = 1'b1; // S0
        end

        // S3 (state[3])
        if (state[3]) begin
            if (in)
                next_state_reg[4] = 1'b1; // S4
            else
                next_state_reg[0] = 1'b1; // S0
        end

        // S4 (state[4])
        if (state[4]) begin
            if (in)
                next_state_reg[5] = 1'b1; // S5
            else
                next_state_reg[0] = 1'b1; // S0
        end

        // S5 (state[5])
        if (state[5]) begin
            if (in)
                next_state_reg[6] = 1'b1; // S6
            else
                next_state_reg[8] = 1'b1; // S8
        end

        // S6 (state[6])
        if (state[6]) begin
            if (in)
                next_state_reg[7] = 1'b1; // S7
            else
                next_state_reg[9] = 1'b1; // S9
        end

        // S7 (state[7])
        if (state[7]) begin
            if (in)
                next_state_reg[7] = 1'b1; // S7
            else
                next_state_reg[0] = 1'b1; // S0
        end

        // S8 (state[8])
        if (state[8]) begin
            if (in)
                next_state_reg[1] = 1'b1; // S1
            else
                next_state_reg[0] = 1'b1; // S0
        end

        // S9 (state[9])
        if (state[9]) begin
            if (in)
                next_state_reg[1] = 1'b1; // S1
            else
                next_state_reg[0] = 1'b1; // S0
        end
    end

    assign next_state = next_state_reg;

    // Outputs:
    // out1 = 1 if state is S8 (state[8]) or S9 (state[9])
    // out2 = 1 if state is S7 (state[7]) or S9 (state[9])
    assign out1 = (state[8] | state[9]);
    assign out2 = (state[7] | state[9]);

endmodule