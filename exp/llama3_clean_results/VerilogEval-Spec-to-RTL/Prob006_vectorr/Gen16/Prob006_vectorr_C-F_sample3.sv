// Parameterized module to reverse the bit ordering of a vector
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input vector
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);
    // Use a direct concatenation to assign bits in reverse order
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
    // For a generic solution, a generate block can still be useful
    // genvar i;
    // generate
    //     for (i = 0; i < WIDTH; i = i + 1) begin
    //         assign out[i] = in[WIDTH-1-i]; // Assign each bit to its reversed position
    //     end
    // endgenerate
endmodule