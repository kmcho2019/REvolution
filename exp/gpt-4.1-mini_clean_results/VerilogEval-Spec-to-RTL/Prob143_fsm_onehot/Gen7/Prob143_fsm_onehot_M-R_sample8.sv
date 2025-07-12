module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output       out1,
    output       out2
);

    integer i;
    always @(*) begin
        // Initialize all next_state bits to 0
        for (i = 0; i < 10; i = i + 1)
            next_state[i] = 1'b0;

        // For each current state, determine the next state based on input 'in'
        // Since state input can be multiple states active, accumulate all next states

        // S0 transitions
        if (state[0]) begin
            if (in == 1'b0)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
        end

        // S1 transitions
        if (state[1]) begin
            if (in == 1'b0)
                next_state[0] = 1'b1;
            else
                next_state[2] = 1'b1;
        end

        // S2 transitions
        if (state[2]) begin
            if (in == 1'b0)
                next_state[0] = 1'b1;
            else
                next_state[3] = 1'b1;
        end

        // S3 transitions
        if (state[3]) begin
            if (in == 1'b0)
                next_state[0] = 1'b1;
            else
                next_state[4] = 1'b1;
        end

        // S4 transitions
        if (state[4]) begin
            if (in == 1'b0)
                next_state[0] = 1'b1;
            else
                next_state[5] = 1'b1;
        end

        // S5 transitions
        if (state[5]) begin
            if (in == 1'b0)
                next_state[8] = 1'b1;
            else
                next_state[6] = 1'b1;
        end

        // S6 transitions
        if (state[6]) begin
            if (in == 1'b0)
                next_state[9] = 1'b1;
            else
                next_state[7] = 1'b1;
        end

        // S7 transitions
        if (state[7]) begin
            if (in == 1'b0)
                next_state[0] = 1'b1;
            else
                next_state[7] = 1'b1;
        end

        // S8 transitions
        if (state[8]) begin
            if (in == 1'b0)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
        end

        // S9 transitions
        if (state[9]) begin
            if (in == 1'b0)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
        end
    end

    // Outputs combinational from current states
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule