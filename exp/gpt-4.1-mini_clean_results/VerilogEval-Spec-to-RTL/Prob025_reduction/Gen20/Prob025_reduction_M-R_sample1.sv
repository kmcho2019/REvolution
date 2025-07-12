module TopModule (
    input  [7:0] in,
    output       parity
);
    // Directly compute even parity using Verilog reduction XOR operator
    assign parity = ^in;
endmodule