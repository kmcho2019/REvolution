module TopModule (
    input  [7:0] in,
    output       parity
);

    // Compute even parity bit as XOR of all input bits.
    // The parity output is '1' if there is an odd number of 1's in 'in',
    // making the total count including this parity bit even.
    assign parity = ^in;  // XOR reduction operator for even parity

endmodule