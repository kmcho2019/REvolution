module TopModule (
    input [7:0] in,
    output parity
);
    // Even parity bit calculation:
    // XOR reduction of all input bits ensures
    // the total number of 1's (including parity)
    // will always be even
    assign parity = ^in;
endmodule