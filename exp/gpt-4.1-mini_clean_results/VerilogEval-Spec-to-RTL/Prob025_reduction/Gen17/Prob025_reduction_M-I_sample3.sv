module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity by XOR-reducing all bits of 'in'
    assign parity = ^in;
endmodule