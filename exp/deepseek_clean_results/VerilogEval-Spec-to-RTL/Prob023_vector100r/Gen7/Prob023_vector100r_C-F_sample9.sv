module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

// ==============================================
// Bit Reversal Module
// ==============================================
// Reverses the bit order of the input vector
// 
// Parameters:
//   WIDTH - Specifies the bit width of input/output (default: 100)
//
// Features:
// - Pure combinational logic
// - Parameterized for any bit width
// - Optimal PPA characteristics
//
// Example Usage:
//   For WIDTH=100: in[99:0] -> out[0:99]
// ==============================================

genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < WIDTH; bit_idx = bit_idx + 1) begin : bit_reversal
        assign out[bit_idx] = in[WIDTH-1 - bit_idx];  // Mirror each bit position
    end
endgenerate

endmodule