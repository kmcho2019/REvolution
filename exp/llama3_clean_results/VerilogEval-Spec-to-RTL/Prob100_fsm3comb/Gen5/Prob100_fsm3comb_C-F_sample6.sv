module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    reg [1:0] next_state_reg;
    reg out_reg;

    always @(*) begin
        case(state)
            2'b00: next_state_reg = in ? 2'b01 : 2'b00; // State A
            2'b01: next_state_reg = in ? 2'b01 : 2'b10; // State B
            2'b10: next_state_reg = in ? 2'b11 : 2'b00; // State C
            2'b11: next_state_reg = in ? 2'b01 : 2'b10; // State D
            default: next_state_reg = 2'b00; // Default next state is A
        endcase
        
        out_reg = (state == 2'b11) ? 1'b1 : 1'b0; // Output is 1 only in state D
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule