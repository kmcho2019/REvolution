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

        // Create a lookup table to store next states and outputs
        case ({state, in})
            // S0
            10'b0000000000, 10'b0000000001: next_state_reg[!in? 0 : 1] = 1'b1;
            // S1
            10'b0000000010, 10'b0000000011: next_state_reg[!in? 0 : 2] = 1'b1;
            // S2
            10'b0000000100, 10'b0000000101: next_state_reg[!in? 0 : 3] = 1'b1;
            // S3
            10'b0000001000, 10'b0000001001: next_state_reg[!in? 0 : 4] = 1'b1;
            // S4
            10'b0000010000, 10'b0000010001: next_state_reg[!in? 0 : 5] = 1'b1;
            // S5
            10'b0000100000, 10'b0000100001: next_state_reg[!in? 8 : 6] = 1'b1;
            // S6
            10'b0001000000, 10'b0001000001: next_state_reg[!in? 9 : 7] = 1'b1;
            // S7
            10'b0010000000, 10'b0010000001: begin
                next_state_reg[!in? 0 : 7] = 1'b1;
                out2_reg = 1'b1;
            end
            // S8
            10'b0100000000, 10'b0100000001: begin
                next_state_reg[!in? 0 : 1] = 1'b1;
                out1_reg = 1'b1;
            end
            // S9
            10'b1000000000, 10'b1000000001: begin
                next_state_reg[!in? 0 : 1] = 1'b1;
                out1_reg = 1'b1;
                out2_reg = 1'b1;
            end
            default: next_state_reg[0] = 1'b1; // Default state
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule