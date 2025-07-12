module TopModule (
    input  [7:0] in,
    output wire parity  // even parity bit
);
    // Compute even parity by XOR-ing all input bits.
    // Parity = 1 if number of 1's in 'in' is odd, making total count including parity even.
    assign parity = ^in;
endmodule