module TopModule (
    input  [7:0] in,
    output       parity
);
    // Directly use Verilog reduction XOR operator to compute even parity
    assign parity = ^in;
endmodule