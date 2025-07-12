module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // The '&' operator in Verilog is a reduction AND operator, 
                          // which performs a bitwise AND operation on all bits of the operand.

    assign out_or = |in;   // The '|' operator in Verilog is a reduction OR operator, 
                          // which performs a bitwise OR operation on all bits of the operand.

    assign out_xor = ^in;  // The '^' operator in Verilog is a reduction XOR operator, 
                           // which performs a bitwise XOR operation on all bits of the operand.

endmodule