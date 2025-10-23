module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity bit for 8-bit input 'in'
    // The parity bit is the XOR of all input bits,
    // yielding 1 if the number of set bits is odd,
    // ensuring total number of 1s including parity is even.
    assign parity = ^in;
endmodule