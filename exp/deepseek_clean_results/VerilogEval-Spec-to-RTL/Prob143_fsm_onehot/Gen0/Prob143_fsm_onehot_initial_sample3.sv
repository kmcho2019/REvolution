module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        // Initialize outputs and next_state
        out1 = 0;
        out2 = 0;
        next_state = 10'b0;

        // Process each possible state bit
        if (state[0]) begin // S0
            if (in) next_state[1] = 1;
            else next_state[0] = 1;
        end
        if (state[1]) begin // S1
            if (in) next_state[2] = 1;
            else next_state[0] = 1;
        end
        if (state[2]) begin // S2
            if (in) next_state[3] = 1;
            else next_state[0] = 1;
        end
        if (state[3]) begin // S3
            if (in) next_state[4] = 1;
            else next_state[0] = 1;
        end
        if (state[4]) begin // S4
            if (in) next_state[5] = 1;
            else next_state[0] = 1;
        end
        if (state[5]) begin // S5
            if (in) next_state[6] = 1;
            else next_state[8] = 1;
        end
        if (state[6]) begin // S6
            if (in) next_state[7] = 1;
            else next_state[9] = 1;
        end
        if (state[7]) begin // S7
            out2 = 1;
            if (in) next_state[7] = 1;
            else next_state[0] = 1;
        end
        if (state[8]) begin // S8
            out1 = 1;
            if (in) next_state[1] = 1;
            else next_state[0] = 1;
        end
        if (state[9]) begin // S9
            out1 = 1;
            out2 = 1;
            if (in) next_state[1] = 1;
            else next_state[0] = 1;
        end
    end

endmodule