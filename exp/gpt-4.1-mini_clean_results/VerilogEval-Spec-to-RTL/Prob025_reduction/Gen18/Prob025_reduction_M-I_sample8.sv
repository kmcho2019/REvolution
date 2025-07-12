module TopModule (
    input  [7:0] in,
    output       parity
);
    // Directly compute even parity by XOR-reducing all bits
    assign parity = ^in;
endmodule