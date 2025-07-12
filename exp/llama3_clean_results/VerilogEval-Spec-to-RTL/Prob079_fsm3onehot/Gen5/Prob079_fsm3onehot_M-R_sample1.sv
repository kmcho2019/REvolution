module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

// State transition logic using continuous assignments
assign next_state = (
    (~in & (state == 4'b0001)) ? 4'b0001 : // A -> A when in=0
    (in & (state == 4'b0001)) ? 4'b0010 : // A -> B when in=1
    (~in & (state == 4'b0010)) ? 4'b0100 : // B -> C when in=0
    (in & (state == 4'b0010)) ? 4'b0010 : // B -> B when in=1
    (~in & (state == 4'b0100)) ? 4'b0001 : // C -> A when in=0
    (in & (state == 4'b0100)) ? 4'b1000 : // C -> D when in=1
    (~in & (state == 4'b1000)) ? 4'b0100 : // D -> C when in=0
    (in & (state == 4'b1000)) ? 4'b0010 : // D -> B when in=1
    4'bxxxx // Default, should not occur
);

// Output logic
assign out = (state == 4'b1000); // Output is 1 only for state D

endmodule