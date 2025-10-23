module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Derive next state logic based on the state transition table
assign next_state = (state == 4'b0001 && !in) ? 4'b0001 : // A to A when in=0
                   (state == 4'b0001 &&  in) ? 4'b0010 : // A to B when in=1
                   (state == 4'b0010 && !in) ? 4'b0100 : // B to C when in=0
                   (state == 4'b0010 &&  in) ? 4'b0010 : // B to B when in=1
                   (state == 4'b0100 && !in) ? 4'b0001 : // C to A when in=0
                   (state == 4'b0100 &&  in) ? 4'b1000 : // C to D when in=1
                   (state == 4'b1000 && !in) ? 4'b0100 : // D to C when in=0
                   (state == 4'b1000 &&  in) ? 4'b0010 : // D to B when in=1
                   4'bxxxx; // Default value, should not occur

// Derive output logic based on the current state
assign out = (state == 4'b1000) ? 1'b1 : // Output is 1 when in state D
             1'b0; // Output is 0 for all other states

endmodule