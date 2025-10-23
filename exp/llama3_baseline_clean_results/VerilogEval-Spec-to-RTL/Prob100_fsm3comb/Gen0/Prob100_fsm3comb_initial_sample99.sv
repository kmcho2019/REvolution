module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: // State A
            begin
                if (!in)
                    next_state = 2'b00; // Next state A if in = 0
                else
                    next_state = 2'b01; // Next state B if in = 1
                out = 1'b0; // Output 0
            end
        2'b01: // State B
            begin
                next_state = in ? 2'b01 : 2'b10; // Next state B if in = 1, C if in = 0
                out = 1'b0; // Output 0
            end
        2'b10: // State C
            begin
                next_state = in ? 2'b11 : 2'b00; // Next state D if in = 1, A if in = 0
                out = 1'b0; // Output 0
            end
        2'b11: // State D
            begin
                next_state = in ? 2'b01 : 2'b10; // Next state B if in = 1, C if in = 0
                out = 1'b1; // Output 1
            end
        default:
            next_state = 2'b00; // Default next state A
            out = 1'b0; // Default output 0
    endcase
end

endmodule