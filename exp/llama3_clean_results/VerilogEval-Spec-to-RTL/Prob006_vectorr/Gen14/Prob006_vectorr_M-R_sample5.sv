// Parameterized module to reverse the bit ordering of a vector
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input vector
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);
    // Use a continuous assignment statement to reverse the bits
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]}; // Assign the reversed bits to the output vector
endmodule