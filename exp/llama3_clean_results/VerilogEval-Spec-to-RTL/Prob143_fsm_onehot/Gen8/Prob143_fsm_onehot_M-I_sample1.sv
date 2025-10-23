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

        case ({in, state})
            // S0
            {1'b0, 10'b0000000001}: next_state_reg[0] = 1'b1;
            {1'b1, 10'b0000000001}: next_state_reg[1] = 1'b1;

            // S1
            {1'b0, 10'b0000000010}: next_state_reg[0] = 1'b1;
            {1'b1, 10'b0000000010}: next_state_reg[2] = 1'b1;

            // S2
            {1'b0, 10'b0000000100}: next_state_reg[0] = 1'b1;
            {1'b1, 10'b0000000100}: next_state_reg[3] = 1'b1;

            // S3
            {1'b0, 10'b0000001000}: next_state_reg[0] = 1'b1;
            {1'b1, 10'b0000001000}: next_state_reg[4] = 1'b1;

            // S4
            {1'b0, 10'b0000010000}: next_state_reg[0] = 1'b1;
            {1'b1, 10'b0000010000}: next_state_reg[5] = 1'b1;

            // S5
            {1'b0, 10'b0000100000}: next_state_reg[8] = 1'b1;
            {1'b1, 10'b0000100000}: next_state_reg[6] = 1'b1;

            // S6
            {1'b0, 10'b0001000000}: next_state_reg[9] = 1'b1;
            {1'b1, 10'b0001000000}: next_state_reg[7] = 1'b1;

            // S7
            {1'b0, 10'b0010000000}: next_state_reg[0] = 1'b1;
            {1'b1, 10'b0010000000}: next_state_reg[7] = 1'b1;
            {1'b0, 10'b0010000000}: out2_reg = 1'b0;
            {1'b1, 10'b0010000000}: out2_reg = 1'b1;

            // S8
            {1'b0, 10'b0100000000}: next_state_reg[0] = 1'b1;
            {1'b1, 10'b0100000000}: next_state_reg[1] = 1'b1;
            {1'b0, 10'b0100000000}: out1_reg = 1'b1;
            {1'b1, 10'b0100000000}: out1_reg = 1'b1;

            // S9
            {1'b0, 10'b1000000000}: next_state_reg[0] = 1'b1;
            {1'b1, 10'b1000000000}: next_state_reg[1] = 1'b1;
            {1'b0, 10'b1000000000}: out1_reg = 1'b1;
            {1'b1, 10'b1000000000}: out1_reg = 1'b1;
            {1'b0, 10'b1000000000}: out2_reg = 1'b1;
            {1'b1, 10'b1000000000}: out2_reg = 1'b1;

            default: next_state_reg[0] = 1'b1;
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule