module TopModule (
    input  [7:0] in,
    output       parity
);

    // Compute even parity by XOR-ing all input bits.
    // parity is 1 if the number of 1s in 'in' is odd,
    // ensuring total number of 1s including parity bit is even.
    assign parity = ^in;

endmodule