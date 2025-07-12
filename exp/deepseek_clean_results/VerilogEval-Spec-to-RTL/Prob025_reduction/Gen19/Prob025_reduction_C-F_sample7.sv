module TopModule (
    input [7:0] in,       // 8-bit input data
    output parity         // Even parity bit
);
    // Even parity is computed as XOR of all input bits
    // This implementation is optimal for PPA:
    // - Single-cycle operation with minimal gate delay
    // - No memory elements required
    // - Minimal power consumption
    assign parity = ^in;
endmodule