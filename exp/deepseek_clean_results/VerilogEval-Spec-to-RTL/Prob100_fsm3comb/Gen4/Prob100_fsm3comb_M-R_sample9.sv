module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State decoding
wire is_A = (state == 2'b00);
wire is_B = (state == 2'b01);
wire is_C = (state == 2'b10);
wire is_D = (state == 2'b11);

// Next state logic using ternary operators
assign next_state[1] = (is_C & in) |          // C->D when in=1
                       (is_D & ~in) |         // D->C when in=0
                       (is_B & ~in);          // B->C when in=0

assign next_state[0] = (is_A & in) |          // A->B when in=1
                       (is_B & in) |          // B->B when in=1
                       (is_D & in);           // D->B when in=1

// Output logic - only high in state D
assign out = is_D;

endmodule