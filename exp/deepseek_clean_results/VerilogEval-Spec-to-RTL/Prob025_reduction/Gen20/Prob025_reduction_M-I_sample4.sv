module TopModule #(
    parameter WIDTH = 8      // Configurable width for reusability
) (
    input  [WIDTH-1:0] in,  // Input data bus
    output parity           // Even parity bit
);

    // Even parity is the XOR of all input bits
    // This creates a single-bit result where '1' means odd number of 1s in input
    assign parity = ^in;

endmodule