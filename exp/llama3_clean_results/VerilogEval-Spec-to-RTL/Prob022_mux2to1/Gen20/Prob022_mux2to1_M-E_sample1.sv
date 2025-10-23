// Module declaration for a 2-to-1 multiplexer implemented using digital logic gates
module TopModule(
    input  a,  // Input a to be selected when sel is 0
    input  b,  // Input b to be selected when sel is 1
    input  sel, // Select input that determines whether a or b is passed to out
    output out  // Output of the multiplexer
);

// Internal wires for the AND gates' outputs
wire and_a_out;
wire and_b_out;

// NOT gate for inverting the select signal
assign sel_inv = ~sel;

// AND gate for input a
assign and_a_out = a & sel_inv;

// AND gate for input b
assign and_b_out = b & sel;

// OR gate to combine the outputs of the AND gates
assign out = and_a_out | and_b_out;

endmodule