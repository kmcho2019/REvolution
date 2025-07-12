module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
assign next_state = (state == 4'b0001 && !in) ? 4'b0001 : // A, in=0 -> A
                   (state == 4'b0001 && in)  ? 4'b0010 : // A, in=1 -> B
                   (state == 4'b0010 && !in) ? 4'b0100 : // B, in=0 -> C
                   (state == 4'b0010 && in)  ? 4'b0010 : // B, in=1 -> B
                   (state == 4'b0100 && !in) ? 4'b0001 : // C, in=0 -> A
                   (state == 4'b0100 && in)  ? 4'b1000 : // C, in=1 -> D
                   (state == 4'b1000 && !in) ? 4'b0100 : // D, in=0 -> C
                   (state == 4'b1000 && in)  ? 4'b0010 : // D, in=1 -> B
                   4'b0000; // default state

// Output logic
assign out = (state == 4'b1000) ? 1'b1 : // Output is 1 when state is D
                 1'b0; // Output is 0 for all other states

endmodule