// Top-level module implementing the 4-input gates
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    assign out_and = &in;  // 4-input AND using bitwise AND
    assign out_or  = |in;   // 4-input OR using bitwise OR
    assign out_xor = ^in;   // 4-input XOR using bitwise XOR
endmodule