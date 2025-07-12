module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic
    assign next_state = (
        (~in & state[0]) ? 4'b0001 : // A to A when in=0
        (~in & state[1]) ? 4'b0100 : // B to C when in=0
        (~in & state[2]) ? 4'b0001 : // C to A when in=0
        (~in & state[3]) ? 4'b0100 : // D to C when in=0
        ( in & state[0]) ? 4'b0010 : // A to B when in=1
        ( in & state[1]) ? 4'b0010 : // B to B when in=1
        ( in & state[2]) ? 4'b1000 : // C to D when in=1
        ( in & state[3]) ? 4'b0010 : // D to B when in=1
        4'bxxxx
    );

    // Output logic
    assign out = state[3]; // Output is high only when in state D

endmodule