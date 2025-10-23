module TopModule (
    input [7:0] in,    // 8-bit input data
    output parity      // Even parity bit (XOR of all input bits)
);
    // Compute even parity: parity = 1 if odd number of 1s in 'in'
    assign parity = ^in;
endmodule