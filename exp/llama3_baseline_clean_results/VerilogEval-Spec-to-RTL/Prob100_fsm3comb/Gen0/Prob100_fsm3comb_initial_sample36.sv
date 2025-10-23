module TopModule(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: // State A
            if (!in) next_state = 2'b00; // Next state when in=0
            else next_state = 2'b01; // Next state when in=1
        2'b01: // State B
            if (!in) next_state = 2'b10; // Next state when in=0
            else next_state = 2'b01; // Next state when in=1
        2'b10: // State C
            if (!in) next_state = 2'b00; // Next state when in=0
            else next_state = 2'b11; // Next state when in=1
        2'b11: // State D
            if (!in) next_state = 2'b10; // Next state when in=0
            else next_state = 2'b01; // Next state when in=1
        default: next_state = 2'b00; // Default next state
    endcase

    case (state)
        2'b00, 2'b01, 2'b10: out = 1'b0; // Output for states A, B, C
        2'b11: out = 1'b1; // Output for state D
        default: out = 1'b0; // Default output
    endcase
end

endmodule