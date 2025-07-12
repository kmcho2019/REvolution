module TopModule (
    input  [7:0] in,
    output       parity
);
    // Use Verilog's reduction XOR operator to compute even parity directly.
    assign parity = ^in;
endmodule