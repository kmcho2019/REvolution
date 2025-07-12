module TopModule (
    input [7:0] in,       // 8-bit input data
    output parity         // Even parity bit (XOR of all input bits)
);
    // Even parity is calculated as the XOR of all input bits
    assign parity = ^in;
endmodule