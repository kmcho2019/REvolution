// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Create a 100-bit vector version of 'sel' and its complement.
wire [99:0] sel_vec = {100{sel}}; // Replicate 'sel' across 100 bits
wire [99:0] sel_not_vec = ~sel_vec; // Bitwise NOT of sel_vec

// Use a vectorized assignment with bitwise operations for the multiplexing.
assign out = (sel_not_vec & a) | (sel_vec & b);

// This implementation combines the efficiency of bitwise operations with the conciseness of vectorized assignment.

endmodule