module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // The & operator is the bitwise AND operator in Verilog
    assign out_or = |in;   // The | operator is the bitwise OR operator in Verilog
    assign out_xor = ^in;  // The ^ operator is the bitwise XOR operator in Verilog

endmodule