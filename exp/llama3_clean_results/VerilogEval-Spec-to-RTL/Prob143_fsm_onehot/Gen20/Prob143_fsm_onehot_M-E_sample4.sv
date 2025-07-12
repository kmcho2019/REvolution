module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [9:0] curr_state;
    reg [9:0] next_state_reg;

    always @(*) begin
        curr_state = state;
        next_state_reg = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        case ({in, curr_state})
            // S0
            10'b0_0000000001: next_state_reg = (in) ? 10'b0_0000000010 : 10'b0_0000000001;
            10'b1_0000000001: next_state_reg = 10'b0_0000000010;

            // S1
            10'b0_0000000010: next_state_reg = (in) ? 10'b0_0000000100 : 10'b0_0000000001;
            10'b1_0000000010: next_state_reg = 10'b0_0000000100;

            // S2
            10'b0_0000000100: next_state_reg = (in) ? 10'b0_0000001000 : 10'b0_0000000001;
            10'b1_0000000100: next_state_reg = 10'b0_0000001000;

            // S3
            10'b0_0000001000: next_state_reg = (in) ? 10'b0_0000010000 : 10'b0_0000000001;
            10'b1_0000001000: next_state_reg = 10'b0_0000010000;

            // S4
            10'b0_0000010000: next_state_reg = (in) ? 10'b0_0000100000 : 10'b0_0000000001;
            10'b1_0000010000: next_state_reg = 10'b0_0000100000;

            // S5
            10'b0_0000100000: next_state_reg = (in) ? 10'b0_0001000000 : 10'b0_0010000000;
            10'b1_0000100000: next_state_reg = 10'b0_0001000000;

            // S6
            10'b0_0001000000: next_state_reg = (in) ? 10'b0_0010000000 : 10'b0_0100000000;
            10'b1_0001000000: next_state_reg = 10'b0_0010000000;

            // S7
            10'b0_0010000000: next_state_reg = (in) ? 10'b0_0010000000 : 10'b0_0000000001;
            10'b1_0010000000: next_state_reg = 10'b0_0010000000;
            10'b0_0010000000: out2 = 1'b1;

            // S8
            10'b0_0100000000: next_state_reg = (in) ? 10'b0_0000000010 : 10'b0_0000000001;
            10'b1_0100000000: next_state_reg = 10'b0_0000000010;
            10'b0_0100000000: out1 = 1'b1;
            10'b1_0100000000: out1 = 1'b1;

            // S9
            10'b0_1000000000: next_state_reg = (in) ? 10'b0_0000000010 : 10'b0_0000000001;
            10'b1_1000000000: next_state_reg = 10'b0_0000000010;
            10'b0_1000000000: out1 = 1'b1;
            10'b0_1000000000: out2 = 1'b1;
            10'b1_1000000000: out1 = 1'b1;
            10'b1_1000000000: out2 = 1'b1;

            default: next_state_reg = 10'b0_0000000001;
        endcase

        next_state = next_state_reg;
    end

endmodule