module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

reg [3:0] next_state_reg; // Internal reg to hold next state value

// State transition logic
always @(*) begin
    case (state)
        4'b0001: // State A
            if (~in) next_state_reg = 4'b0001; // A -> A when in=0
            else next_state_reg = 4'b0010; // A -> B when in=1
        4'b0010: // State B
            if (~in) next_state_reg = 4'b0100; // B -> C when in=0
            else next_state_reg = 4'b0010; // B -> B when in=1
        4'b0100: // State C
            if (~in) next_state_reg = 4'b0001; // C -> A when in=0
            else next_state_reg = 4'b1000; // C -> D when in=1
        4'b1000: // State D
            if (~in) next_state_reg = 4'b0100; // D -> C when in=0
            else next_state_reg = 4'b0010; // D -> B when in=1
        default: next_state_reg = 4'bxxxx; // Invalid state, next_state undefined
    endcase
end

// Assign next_state_reg to output port next_state
assign next_state = next_state_reg;

// Output logic
assign out = (state == 4'b1000); // Output is 1 only for state D

endmodule