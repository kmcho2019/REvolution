module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

// Bit reversal module with configurable width
// Reverses the bit order of the input vector
// Parameters:
//   WIDTH - bit width of input/output (default: 100)
// Example: 
//   For WIDTH=100: in[99:0] -> out[0:99]

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
        assign out[i] = in[WIDTH-1 - i];  // Mirror the bits
    end
endgenerate

endmodule