module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Parameterized bit reversal module
// Reverses the bit order of the input vector
// Example: in[99:0] -> out[0:99]

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : reverse_bits
        assign out[i] = in[99 - i];  // Mirror the bits
    end
endgenerate

endmodule