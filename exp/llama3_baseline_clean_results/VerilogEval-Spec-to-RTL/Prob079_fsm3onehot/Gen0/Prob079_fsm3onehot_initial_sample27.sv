module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic: out is 1 only when state is D (4'b1000)
assign out = state[3]; // Since D is 4'b1000, out is 1 only if the most significant bit of state is 1

// Next state logic
always @(*) begin
    case(state)
        4'b0001: // State A
            if (!in) next_state = 4'b0001; // in=0, next state is A
            else next_state = 4'b0010; // in=1, next state is B
        4'b0010: // State B
            if (!in) next_state = 4'b0100; // in=0, next state is C
            else next_state = 4'b0010; // in=1, next state is B
        4'b0100: // State C
            if (!in) next_state = 4'b0001; // in=0, next state is A
            else next_state = 4'b1000; // in=1, next state is D
        4'b1000: // State D
            if (!in) next_state = 4'b0100; // in=0, next state is C
            else next_state = 4'b0010; // in=1, next state is B
        default: next_state = 4'bxxxx; // Invalid state, next state is undefined
    endcase
end

endmodule