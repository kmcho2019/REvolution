module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
assign out = state[3]; // 1 only when in state D (4'b1000)

// State transition logic
assign next_state = 
    (state == 4'b0001 && !in) ? 4'b0001 : // From A to A when in=0
    (state == 4'b0001 &&  in) ? 4'b0010 : // From A to B when in=1
    (state == 4'b0010 && !in) ? 4'b0100 : // From B to C when in=0
    (state == 4'b0010 &&  in) ? 4'b0010 : // From B to B when in=1
    (state == 4'b0100 && !in) ? 4'b0001 : // From C to A when in=0
    (state == 4'b0100 &&  in) ? 4'b1000 : // From C to D when in=1
    (state == 4'b1000 && !in) ? 4'b0100 : // From D to C when in=0
    (state == 4'b1000 &&  in) ? 4'b0010 : 4'bxxxx; // From D to B when in=1, default to undefined

endmodule