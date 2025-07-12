module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [9:0] next_state_temp;
    reg out1_temp;
    reg out2_temp;

    always @(*) begin
        next_state_temp = 10'b0; // Initialize next_state to zero
        out1_temp = 1'b0; // Initialize out1 to zero
        out2_temp = 1'b0; // Initialize out2 to zero

        case ({state, in})
            // S0
            10'b1_0, 10'b1_1: next_state_temp[0] = 1'b1;
            // S1
            10'b10_0: next_state_temp[0] = 1'b1;
            10'b10_1: next_state_temp[1] = 1'b1;
            // S2
            10'b100_0: next_state_temp[0] = 1'b1;
            10'b100_1: next_state_temp[2] = 1'b1;
            // S3
            10'b1000_0: next_state_temp[0] = 1'b1;
            10'b1000_1: next_state_temp[3] = 1'b1;
            // S4
            10'b10000_0: next_state_temp[0] = 1'b1;
            10'b10000_1: next_state_temp[4] = 1'b1;
            // S5
            10'b100000_0: next_state_temp[8] = 1'b1;
            10'b100000_1: next_state_temp[5] = 1'b1;
            // S6
            10'b1000000_0: next_state_temp[9] = 1'b1;
            10'b1000000_1: next_state_temp[6] = 1'b1;
            // S7
            10'b10000000_0: next_state_temp[0] = 1'b1;
            10'b10000000_1: next_state_temp[7] = 1'b1;
            // S8
            10'b100000000_0: next_state_temp[0] = 1'b1;
            10'b100000000_1: next_state_temp[1] = 1'b1;
            // S9
            10'b1000000000_0: next_state_temp[0] = 1'b1;
            10'b1000000000_1: next_state_temp[1] = 1'b1;
            default: next_state_temp[0] = 1'b1;
        endcase

        case (state)
            10'b100000000: out1_temp = 1'b1;
            10'b1000000000: out1_temp = 1'b1;
            10'b10000000: out2_temp = 1'b1;
            10'b1000000000: out2_temp = 1'b1;
            default: ;
        endcase

        next_state = next_state_temp;
        out1 = out1_temp;
        out2 = out2_temp;
    end

endmodule