module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
always_comb begin
    case (state)
        4'b0001: // State A
            if (~in) next_state = 4'b0001; // Next state A when in=0
            else next_state = 4'b0010; // Next state B when in=1
        4'b0010: // State B
            if (~in) next_state = 4'b0100; // Next state C when in=0
            else next_state = 4'b0010; // Next state B when in=1
        4'b0100: // State C
            if (~in) next_state = 4'b0001; // Next state A when in=0
            else next_state = 4'b1000; // Next state D when in=1
        4'b1000: // State D
            if (~in) next_state = 4'b0100; // Next state C when in=0
            else next_state = 4'b0010; // Next state B when in=1
        default:
            next_state = 4'b0000; // Default next state, should not occur with valid input
    endcase
end

// Output logic
assign out = (state == 4'b1000); // Output 1 when in state D, 0 otherwise

endmodule