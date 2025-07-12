module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // The & operator in Verilog performs a reduction AND
    assign out_or = |in;   // The | operator in Verilog performs a reduction OR
    assign out_xor = ^in;  // The ^ operator in Verilog performs a reduction XOR

endmodule