// Parameterized module to reverse the bit ordering of a vector
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input vector
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);
    // Use a generate block with a for loop to reverse the bits
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            assign out[i] = in[WIDTH-1-i]; // Assign the reversed bits to the output vector
        end
    endgenerate
endmodule