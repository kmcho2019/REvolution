module TopModule (
    input  [7:0] in,
    output       parity
);
    // Use Verilog reduction XOR operator for even parity calculation
    assign parity = ^in;
endmodule