// Parameterized module to reverse the bit ordering of an input vector
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input/output vectors
)(
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);

    // Use a for-loop to iterate through the input bits and assign them to the output bits in reverse order
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate

endmodule