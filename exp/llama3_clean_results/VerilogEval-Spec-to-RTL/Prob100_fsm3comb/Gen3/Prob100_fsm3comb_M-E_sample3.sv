module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(*) begin
        case(state)
            2'b00: next_state = in ? 2'b01 : 2'b00; // State A
            2'b01: next_state = in ? 2'b01 : 2'b10; // State B
            2'b10: next_state = in ? 2'b11 : 2'b00; // State C
            2'b11: next_state = in ? 2'b01 : 2'b10; // State D
            default: next_state = 2'b00; // Default next state is A
        endcase
        
        out = (state == 2'b11) ? 1'b1 : 1'b0; // Output is 1 only in state D
    end

endmodule