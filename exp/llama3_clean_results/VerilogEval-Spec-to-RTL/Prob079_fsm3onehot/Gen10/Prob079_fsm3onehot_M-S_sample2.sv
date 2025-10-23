module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = state[3]; // D state is the only one that outputs 1

    // Simplified state transition logic
    assign next_state = 
        (~in & (state == 4'b0001)) ? 4'b0001 : // A to A when in=0
        ( in & (state == 4'b0001)) ? 4'b0010 : // A to B when in=1
        (~in & (state == 4'b0010)) ? 4'b0100 : // B to C when in=0
        ( in & (state == 4'b0010)) ? 4'b0010 : // B to B when in=1
        (~in & (state == 4'b0100)) ? 4'b0001 : // C to A when in=0
        ( in & (state == 4'b0100)) ? 4'b1000 : // C to D when in=1
        (~in & (state == 4'b1000)) ? 4'b0100 : // D to C when in=0
        ( in & (state == 4'b1000)) ? 4'b0010 : 4'bxxxx; // D to B when in=1

endmodule