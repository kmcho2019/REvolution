module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector (reversed input)
);

    // Generate block to reverse the input vector
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            // Assign each output bit to the corresponding reversed input bit
            assign out[WIDTH - 1 - i] = in[i];
        end
    endgenerate

endmodule