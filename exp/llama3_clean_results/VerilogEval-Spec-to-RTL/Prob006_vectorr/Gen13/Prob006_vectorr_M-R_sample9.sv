// Refactored module to reverse the bit ordering of a vector using continuous assignment
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input vector
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);
    // Use continuous assignment to reverse the bits
    assign out = {in[WIDTH-1], in[WIDTH-2], in[WIDTH-3], in[WIDTH-4], in[WIDTH-5], in[WIDTH-6], in[WIDTH-7], in[0]};
endmodule