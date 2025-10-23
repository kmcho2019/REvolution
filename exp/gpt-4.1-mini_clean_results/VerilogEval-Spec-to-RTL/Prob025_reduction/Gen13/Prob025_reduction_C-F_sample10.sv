// TopModule: 8-bit even parity generator using XOR reduction operator.
// Computes even parity bit for the 8-bit input vector 'in'.
module TopModule (
    input  [7:0] in,    // 8-bit input data
    output       parity // Even parity output: XOR of all bits in 'in'
);
    // Compute even parity as XOR reduction of input bits
    assign parity = ^in;
endmodule