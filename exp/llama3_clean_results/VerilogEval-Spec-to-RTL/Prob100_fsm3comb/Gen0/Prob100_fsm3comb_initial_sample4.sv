module TopModule(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    case(state)
        2'b00: // State A
            begin
                if (~in) next_state = 2'b00; // Next state in=0, A
                else next_state = 2'b01; // Next state in=1, B
                out = 1'b0; // Output
            end
        2'b01: // State B
            begin
                if (~in) next_state = 2'b10; // Next state in=0, C
                else next_state = 2'b01; // Next state in=1, B
                out = 1'b0; // Output
            end
        2'b10: // State C
            begin
                if (~in) next_state = 2'b00; // Next state in=0, A
                else next_state = 2'b11; // Next state in=1, D
                out = 1'b0; // Output
            end
        2'b11: // State D
            begin
                if (~in) next_state = 2'b10; // Next state in=0, C
                else next_state = 2'b01; // Next state in=1, B
                out = 1'b1; // Output
            end
        default: // Invalid state
            begin
                next_state = 2'b00; // Default next state
                out = 1'b0; // Default output
            end
    endcase
end

endmodule