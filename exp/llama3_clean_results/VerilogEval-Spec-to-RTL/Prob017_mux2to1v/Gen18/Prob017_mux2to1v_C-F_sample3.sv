// Module TopModule implements a 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    // 100-bit input vectors a and b
    input  [99:0] a,  
    input  [99:0] b,  
    // 1-bit select input sel
    input  sel,       
    // 100-bit output vector out
    output [99:0] out 
);

// Use the ternary operator to select between 'a' and 'b' based on 'sel'.
// This approach simplifies the code, maintains original functionality, and is efficient.
assign out = sel ? b : a;

endmodule