module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic: out is 1 only when the current state is D (4'b1000)
assign out = state[3]; // Since D is encoded as 4'b1000, out is 1 when state[3] is 1

// Next state logic
always @(*) begin
    case (state)
        4'b0001: // State A
            if (~in) next_state = 4'b0001; // Next state is A when 'in' is 0
            else next_state = 4'b0010; // Next state is B when 'in' is 1
        4'b0010: // State B
            if (~in) next_state = 4'b0100; // Next state is C when 'in' is 0
            else next_state = 4'b0010; // Next state is B when 'in' is 1
        4'b0100: // State C
            if (~in) next_state = 4'b0001; // Next state is A when 'in' is 0
            else next_state = 4'b1000; // Next state is D when 'in' is 1
        4'b1000: // State D
            if (~in) next_state = 4'b0100; // Next state is C when 'in' is 0
            else next_state = 4'b0010; // Next state is B when 'in' is 1
        default: next_state = 4'b0000; // Default next state, should not occur with one-hot encoding
    endcase
end

endmodule