module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

always @(*) begin
    case(state)
        4'b0001: begin // State A
            if (!in) next_state = 4'b0001; // Next state A when in=0
            else next_state = 4'b0010; // Next state B when in=1
            out = 1'b0; // Output 0 in state A
        end
        4'b0010: begin // State B
            if (!in) next_state = 4'b0100; // Next state C when in=0
            else next_state = 4'b0010; // Next state B when in=1
            out = 1'b0; // Output 0 in state B
        end
        4'b0100: begin // State C
            if (!in) next_state = 4'b0001; // Next state A when in=0
            else next_state = 4'b1000; // Next state D when in=1
            out = 1'b0; // Output 0 in state C
        end
        4'b1000: begin // State D
            if (!in) next_state = 4'b0100; // Next state C when in=0
            else next_state = 4'b0010; // Next state B when in=1
            out = 1'b1; // Output 1 in state D
        end
        default: begin
            next_state = 4'b0000; // Default next state
            out = 1'b0; // Default output
        end
    endcase
end

endmodule