module TopModule(
    input  [7:0] in,
    output       parity
);
    // Use Verilog reduction XOR operator to compute parity directly
    assign parity = ^in;
endmodule