module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case(state)
        2'b00: begin // State A
            if(!in) next_state = 2'b00; // Next state A when in = 0
            else next_state = 2'b01; // Next state B when in = 1
            out = 1'b0; // Output 0 in state A
        end
        2'b01: begin // State B
            if(!in) next_state = 2'b10; // Next state C when in = 0
            else next_state = 2'b01; // Next state B when in = 1
            out = 1'b0; // Output 0 in state B
        end
        2'b10: begin // State C
            if(!in) next_state = 2'b00; // Next state A when in = 0
            else next_state = 2'b11; // Next state D when in = 1
            out = 1'b0; // Output 0 in state C
        end
        2'b11: begin // State D
            if(!in) next_state = 2'b10; // Next state C when in = 0
            else next_state = 2'b01; // Next state B when in = 1
            out = 1'b1; // Output 1 in state D
        end
        default: begin
            next_state = 2'b00; // Default next state A
            out = 1'b0; // Default output 0
        end
    endcase
end

endmodule