module TopModule(
    input  in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
assign out = (state == 4'b1000); // Out is 1 only when the state is D

// Next state logic
assign next_state = (
    (state == 4'b0001 && !in) ? 4'b0001 : // A -> A when in=0
    (state == 4'b0001 &&  in) ? 4'b0010 : // A -> B when in=1
    (state == 4'b0010 && !in) ? 4'b0100 : // B -> C when in=0
    (state == 4'b0010 &&  in) ? 4'b0010 : // B -> B when in=1
    (state == 4'b0100 && !in) ? 4'b0001 : // C -> A when in=0
    (state == 4'b0100 &&  in) ? 4'b1000 : // C -> D when in=1
    (state == 4'b1000 && !in) ? 4'b0100 : // D -> C when in=0
    (state == 4'b1000 &&  in) ? 4'b0010 : // D -> B when in=1
    4'b0000 // default next state
);

endmodule