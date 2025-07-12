module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        // Handle S0, S8, and S9 states
        if (state[0] || state[8] || state[9]) begin
            next_state_reg[in? 1 : 0] = 1'b1;
            if (state[8] || state[9]) out1_reg = 1'b1;
            if (state[9]) out2_reg = 1'b1;
        end

        // Handle states S1 to S7
        if (state[1]) next_state_reg[in? 2 : 0] = 1'b1;
        if (state[2]) next_state_reg[in? 3 : 0] = 1'b1;
        if (state[3]) next_state_reg[in? 4 : 0] = 1'b1;
        if (state[4]) next_state_reg[in? 5 : 0] = 1'b1;
        if (state[5]) next_state_reg[in? 6 : 8] = 1'b1;
        if (state[6]) next_state_reg[in? 7 : 9] = 1'b1;
        if (state[7]) begin
            next_state_reg[in? 7 : 0] = 1'b1;
            out2_reg = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule