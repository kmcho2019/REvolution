module TopModule(in, out_and, out_or, out_xor);
    input [99:0] in;
    output out_and;
    output out_or;
    output out_xor;

    assign out_and = &in;  // Bitwise AND reduction operator (&) applies AND to all bits in in
    assign out_or  = |in;  // Bitwise OR reduction operator (|) applies OR to all bits in in
    assign out_xor = ^in;  // Bitwise XOR reduction operator (^) applies XOR to all bits in in

endmodule