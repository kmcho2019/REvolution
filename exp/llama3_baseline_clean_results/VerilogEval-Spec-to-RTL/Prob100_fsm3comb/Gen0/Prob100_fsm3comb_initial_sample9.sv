module TopModule(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

always @(state or in) begin
    case (state)
        2'b00: // State A
            if (!in) next_state = 2'b00; // in = 0, next state is A
            else next_state = 2'b01; // in = 1, next state is B
        2'b01: // State B
            if (!in) next_state = 2'b10; // in = 0, next state is C
            else next_state = 2'b01; // in = 1, next state is B
        2'b10: // State C
            if (!in) next_state = 2'b00; // in = 0, next state is A
            else next_state = 2'b11; // in = 1, next state is D
        2'b11: // State D
            if (!in) next_state = 2'b10; // in = 0, next state is C
            else next_state = 2'b01; // in = 1, next state is B
        default:
            next_state = 2'b00; // Default next state
    endcase

    case (state)
        2'b00, 2'b01, 2'b10: out = 1'b0; // States A, B, C output 0
        2'b11: out = 1'b1; // State D output 1
    endcase
end

endmodule