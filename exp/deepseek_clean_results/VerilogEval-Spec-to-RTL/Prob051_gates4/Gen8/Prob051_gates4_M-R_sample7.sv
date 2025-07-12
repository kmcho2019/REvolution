module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Explicit implementation of reduction operations
    // AND: All bits must be 1
    assign out_and = in[3] & in[2] & in[1] & in[0];
    
    // OR: Any bit must be 1
    assign out_or = in[3] | in[2] | in[1] | in[0];
    
    // XOR: Odd number of bits must be 1
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule