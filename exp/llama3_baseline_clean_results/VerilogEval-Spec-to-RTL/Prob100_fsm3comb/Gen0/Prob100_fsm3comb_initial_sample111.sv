module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case(state)
        2'b00: // State A
            if (~in) next_state = 2'b00; // Next state is A if in=0
            else next_state = 2'b01; // Next state is B if in=1
            out = 1'b0; // Output is 0
        2'b01: // State B
            if (~in) next_state = 2'b10; // Next state is C if in=0
            else next_state = 2'b01; // Next state is B if in=1
            out = 1'b0; // Output is 0
        2'b10: // State C
            if (~in) next_state = 2'b00; // Next state is A if in=0
            else next_state = 2'b11; // Next state is D if in=1
            out = 1'b0; // Output is 0
        2'b11: // State D
            if (~in) next_state = 2'b10; // Next state is C if in=0
            else next_state = 2'b01; // Next state is B if in=1
            out = 1'b1; // Output is 1
        default: // Invalid state, default to state A
            next_state = 2'b00;
            out = 1'b0;
    endcase
end

endmodule