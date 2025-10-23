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

        // Handle transitions for states S0, S8, and S9
        if (state[0] || state[8] || state[9]) begin
            next_state[in ? 1 : 0] = 1'b1;
            if (state[8] || state[9]) out1 = 1'b1;
            if (state[9]) out2 = 1'b1;
        end

        // Handle transitions for states S1 to S7
        if (state[1]) next_state[in ? 2 : 0] = 1'b1;
        if (state[2]) next_state[in ? 3 : 0] = 1'b1;
        if (state[3]) next_state[in ? 4 : 0] = 1'b1;
        if (state[4]) next_state[in ? 5 : 0] = 1'b1;
        if (state[5]) next_state[in ? 6 : 8] = 1'b1;
        if (state[6]) next_state[in ? 7 : 9] = 1'b1;
        if (state[7]) begin
            next_state[in ? 7 : 0] = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule