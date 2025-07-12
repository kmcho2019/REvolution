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

// Next state calculation
wire next_A = (is_A & ~in) | (is_C & ~in);
wire next_B = (is_A & in) | (is_B & in) | (is_D & in);
wire next_C = (is_B & ~in) | (is_D & ~in);
wire next_D = (is_C & in);

// Next state encoding
assign next_state[1] = next_C | next_D;
assign next_state[0] = next_B | next_D;

// Output logic
assign out = is_D;

endmodule