// TopModule: A parameterized module that reverses the bit ordering of the input.
module TopModule #(
    // Parameter for the width of the input and output
    parameter WIDTH = 100
) (
    // Input signal
    input  [WIDTH-1:0] in,
    // Output signal with reversed bit order
    output [WIDTH-1:0] out
);

    // Generate block to create the output bits
    genvar i;
    generate
        // Loop through each bit of the input
        for (i = 0; i < WIDTH; i++) begin
            // Assign the input bit to the corresponding output bit in the reversed order
            assign out[WIDTH - 1 - i] = in[i];
        end
    endgenerate

endmodule