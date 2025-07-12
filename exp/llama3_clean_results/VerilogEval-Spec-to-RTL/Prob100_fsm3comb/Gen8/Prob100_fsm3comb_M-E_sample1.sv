module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    reg [1:0] next_state_reg;
    reg out_reg;

    // Look-up table for next state logic
    always @(*) begin
        case({state, in})
            3'b000: next_state_reg = 2'b00; // State A, in = 0
            3'b001: next_state_reg = 2'b01; // State A, in = 1
            3'b010: next_state_reg = 2'b10; // State B, in = 0
            3'b011: next_state_reg = 2'b01; // State B, in = 1
            3'b100: next_state_reg = 2'b00; // State C, in = 0
            3'b101: next_state_reg = 2'b11; // State C, in = 1
            3'b110: next_state_reg = 2'b10; // State D, in = 0
            3'b111: next_state_reg = 2'b01; // State D, in = 1
            default: next_state_reg = 2'b00; // Default next state is A
        endcase
    end

    // Look-up table for output logic
    always @(*) begin
        case(state)
            2'b00: out_reg = 1'b0; // State A
            2'b01: out_reg = 1'b0; // State B
            2'b10: out_reg = 1'b0; // State C
            2'b11: out_reg = 1'b1; // State D
            default: out_reg = 1'b0; // Default output is 0
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule