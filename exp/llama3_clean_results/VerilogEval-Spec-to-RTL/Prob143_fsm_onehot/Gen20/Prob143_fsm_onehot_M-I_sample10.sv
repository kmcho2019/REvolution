module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        // Handle S0, S8, and S9 states
        if (state[0] || state[8] || state[9]) begin
            next_state[in? 1 : 0] = 1'b1;
            if (state[8] || state[9]) out1 = 1'b1;
            if (state[9]) out2 = 1'b1;
        end

        // Handle states S1 to S7
        for (int i = 1; i <= 7; i++) begin
            if (state[i]) begin
                if (i == 5) begin
                    next_state[in? 6 : 8] = 1'b1;
                end else if (i == 6) begin
                    next_state[in? 7 : 9] = 1'b1;
                end else if (i == 7) begin
                    next_state[in? 7 : 0] = 1'b1;
                    out2 = 1'b1;
                end else begin
                    next_state[in? (i + 1) : 0] = 1'b1;
                end
            end
        end
    end

endmodule