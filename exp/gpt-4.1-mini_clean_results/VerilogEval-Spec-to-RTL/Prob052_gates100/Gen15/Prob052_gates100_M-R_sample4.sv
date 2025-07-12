module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Use Verilog reduction operators for concise and efficient combinational logic
    assign out_and = &in;  // 100-input AND reduction
    assign out_or  = |in;  // 100-input OR reduction
    assign out_xor = ^in;  // 100-input XOR (parity) reduction

endmodule