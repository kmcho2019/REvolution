module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // & operator is used for reduction AND operation
    assign out_or = |in;   // | operator is used for reduction OR operation
    assign out_xor = ^in;  // ^ operator is used for reduction XOR operation

endmodule