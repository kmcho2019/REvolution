module TopModule (
    input [7:0] in,    // 8-bit input data
    output parity      // Even parity bit (XOR of all input bits)
);
    // Compute even parity using XOR reduction
    assign parity = ^in;
endmodule