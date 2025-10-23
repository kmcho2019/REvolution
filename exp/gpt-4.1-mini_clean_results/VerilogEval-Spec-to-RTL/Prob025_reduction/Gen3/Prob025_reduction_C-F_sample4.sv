module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity by XOR reduction of all bits in input.
    // The result is 1 if the number of set bits in 'in' is odd,
    // making total 1s including parity bit even.
    assign parity = ^in;
endmodule