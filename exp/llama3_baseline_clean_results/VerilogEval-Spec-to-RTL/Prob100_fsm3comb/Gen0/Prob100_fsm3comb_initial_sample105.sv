module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always_comb begin
    case (state)
        2'b00: begin // State A
            next_state = in ? 2'b01 : 2'b00; // Next state based on input
            out = 1'b0; // Output in state A
        end
        2'b01: begin // State B
            next_state = in ? 2'b01 : 2'b10; // Next state based on input
            out = 1'b0; // Output in state B
        end
        2'b10: begin // State C
            next_state = in ? 2'b11 : 2'b00; // Next state based on input
            out = 1'b0; // Output in state C
        end
        2'b11: begin // State D
            next_state = in ? 2'b01 : 2'b10; // Next state based on input
            out = 1'b1; // Output in state D
        end
        default: begin
            next_state = 2'b00; // Default next state
            out = 1'b0; // Default output
        end
    endcase
end

endmodule