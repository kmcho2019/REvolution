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

        if (state[0]) next_state_reg[!in? 0 : 1] = 1'b1;
        if (state[1]) next_state_reg[!in? 0 : 2] = 1'b1;
        if (state[2]) next_state_reg[!in? 0 : 3] = 1'b1;
        if (state[3]) next_state_reg[!in? 0 : 4] = 1'b1;
        if (state[4]) next_state_reg[!in? 0 : 5] = 1'b1;
        if (state[5]) next_state_reg[!in? 8 : 6] = 1'b1;
        if (state[6]) next_state_reg[!in? 9 : 7] = 1'b1;
        if (state[7]) begin
            next_state_reg[!in? 0 : 7] = 1'b1;
            out2_reg = 1'b1;
        end
        if (state[8]) begin
            next_state_reg[!in? 0 : 1] = 1'b1;
            out1_reg = 1'b1;
        end
        if (state[9]) begin
            next_state_reg[!in? 0 : 1] = 1'b1;
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule