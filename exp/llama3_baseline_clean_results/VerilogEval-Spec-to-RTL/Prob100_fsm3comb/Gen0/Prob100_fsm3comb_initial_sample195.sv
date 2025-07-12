module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*)
begin
    case (state)
        2'b00: // State A
            if (~in) next_state = 2'b00; // Next state is A when in=0
            else next_state = 2'b01; // Next state is B when in=1
            out = 1'b0; // Output is 0
        2'b01: // State B
            next_state = in ? 2'b01 : 2'b10; // Next state is B when in=1, C when in=0
            out = 1'b0; // Output is 0
        2'b10: // State C
            next_state = in ? 2'b11 : 2'b00; // Next state is D when in=1, A when in=0
            out = 1'b0; // Output is 0
        2'b11: // State D
            next_state = in ? 2'b01 : 2'b10; // Next state is B when in=1, C when in=0
            out = 1'b1; // Output is 1
        default:
            next_state = 2'b00; // Default next state
            out = 1'b0; // Default output
    endcase
end

endmodule