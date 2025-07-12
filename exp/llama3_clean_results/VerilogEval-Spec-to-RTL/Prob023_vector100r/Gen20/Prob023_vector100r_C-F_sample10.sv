// Define the TopModule with a parameterized width
module TopModule #(
    // Parameter for the width of the input and output
    parameter WIDTH = 100
) (
    // Input signal
    input  [WIDTH-1:0] in,
    // Output signal with reversed bit order
    output [WIDTH-1:0] out
);

// Generate block to create assignment statements for bit reversal
genvar i;
generate
    for (i = 0; i < WIDTH; i++) begin
        // Assign each output bit to the corresponding input bit in reverse order
        assign out[WIDTH - 1 - i] = in[i];
    end
endgenerate

endmodule