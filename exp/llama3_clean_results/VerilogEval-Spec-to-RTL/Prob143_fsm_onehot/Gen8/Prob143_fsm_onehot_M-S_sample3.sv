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

        case (1'b1)
            state[0]: next_state_reg = in ? 10'b0000000010 : 10'b1000000000;
            state[1]: next_state_reg = in ? 10'b0000000100 : 10'b1000000000;
            state[2]: next_state_reg = in ? 10'b0000001000 : 10'b1000000000;
            state[3]: next_state_reg = in ? 10'b0000010000 : 10'b1000000000;
            state[4]: next_state_reg = in ? 10'b0000100000 : 10'b1000000000;
            state[5]: next_state_reg = in ? 10'b0001000000 : 10'b1000000000;
            state[6]: next_state_reg = in ? 10'b0010000000 : 10'b1000000000;
            state[7]: next_state_reg = in ? 10'b0100000000 : 10'b1000000000;
            state[8]: next_state_reg = in ? 10'b0000000010 : 10'b1000000000;
            state[9]: next_state_reg = in ? 10'b0000000010 : 10'b1000000000;
        endcase

        if (state[7]) begin
            out2_reg = in;
        end
        if (state[8] || state[9]) begin
            out1_reg = 1'b1;
        end
        if (state[9]) begin
            out2_reg = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule