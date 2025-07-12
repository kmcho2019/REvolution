module TopModule (
    input  [7:0] in,
    output       parity
);
    // Use the Verilog reduction XOR operator to compute even parity
    assign parity = ^in;
endmodule