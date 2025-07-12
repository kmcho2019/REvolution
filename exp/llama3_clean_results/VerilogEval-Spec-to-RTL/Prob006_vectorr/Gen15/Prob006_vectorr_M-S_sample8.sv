// Simplified parameterized module to reverse the bit ordering of a vector
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input vector
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);
    // Directly assign the reversed bits
    assign out = {<< {in}}; // Use bit reversal operator to reverse the bits
endmodule