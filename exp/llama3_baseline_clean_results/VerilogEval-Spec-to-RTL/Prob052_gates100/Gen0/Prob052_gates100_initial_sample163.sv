module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in;  // Verilog's reduction AND operator (&) performs a bitwise AND on all bits
assign out_or  = |in;  // Verilog's reduction OR operator (|) performs a bitwise OR on all bits
assign out_xor = ^in;  // Verilog's reduction XOR operator (^) performs a bitwise XOR on all bits

endmodule