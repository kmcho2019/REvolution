module TopModule #(
    parameter WIDTH = 8     // Configurable input width (default 8-bit)
) (
    input [WIDTH-1:0] in,  // Input data of configurable width
    output parity          // Even parity bit (XOR of all input bits)
);
    // Compute even parity by XORing all input bits
    // This gives 0 for even number of 1s, 1 for odd number of 1s
    // Works for any WIDTH >= 1
    assign parity = ^in;
endmodule