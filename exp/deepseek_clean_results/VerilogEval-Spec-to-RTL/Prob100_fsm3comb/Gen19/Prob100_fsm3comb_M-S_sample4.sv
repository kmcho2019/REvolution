module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output is high only when both state bits are 1 (state D)
assign out = &state;

// State transition logic using concatenated state+input as selector
assign next_state =
    ({state, in} == 3'b000) ? 2'b00 : // A, in=0 → A
    ({state, in} == 3'b001) ? 2'b01 : // A, in=1 → B
    ({state, in} == 3'b010) ? 2'b10 : // B, in=0 → C
    ({state, in} == 3'b011) ? 2'b01 : // B, in=1 → B
    ({state, in} == 3'b100) ? 2'b00 : // C, in=0 → A
    ({state, in} == 3'b101) ? 2'b11 : // C, in=1 → D
    ({state, in} == 3'b110) ? 2'b10 : // D, in=0 → C
    2'b01;                            // D, in=1 → B

endmodule