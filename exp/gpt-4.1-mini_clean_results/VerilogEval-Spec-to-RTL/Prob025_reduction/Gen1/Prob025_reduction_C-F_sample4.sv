module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity by XOR'ing all bits of the input.
    // The XOR reduction operator is efficiently implemented as a balanced tree,
    // resulting in minimal combinational delay and area.
    assign parity = ^in;
endmodule