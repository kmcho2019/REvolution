module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        if (state[0]) begin // S0
            next_state[!in? 0 : 1] = 1'b1;
        end

        if (state[1]) begin // S1
            next_state[!in? 0 : 2] = 1'b1;
        end

        if (state[2]) begin // S2
            next_state[!in? 0 : 3] = 1'b1;
        end

        if (state[3]) begin // S3
            next_state[!in? 0 : 4] = 1'b1;
        end

        if (state[4]) begin // S4
            next_state[!in? 0 : 5] = 1'b1;
        end

        if (state[5]) begin // S5
            next_state[!in? 8 : 6] = 1'b1;
        end

        if (state[6]) begin // S6
            next_state[!in? 9 : 7] = 1'b1;
        end

        if (state[7]) begin // S7
            next_state[!in? 0 : 7] = 1'b1;
            out2 = 1'b1;
        end

        if (state[8]) begin // S8
            next_state[!in? 0 : 1] = 1'b1;
            out1 = 1'b1;
        end

        if (state[9]) begin // S9
            next_state[!in? 0 : 1] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule