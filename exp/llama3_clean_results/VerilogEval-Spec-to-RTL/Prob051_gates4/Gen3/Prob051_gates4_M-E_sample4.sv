// Top-level module implementing all gate operations within a single module
module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Bitwise AND operation
    assign out_or  = |in;  // Bitwise OR operation
    assign out_xor = ^in;  // Bitwise XOR operation

endmodule