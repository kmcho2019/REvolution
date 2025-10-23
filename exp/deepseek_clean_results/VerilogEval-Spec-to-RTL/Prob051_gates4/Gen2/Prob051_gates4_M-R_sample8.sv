module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND operation: all bits must be 1
    assign out_and = in[3] & in[2] & in[1] & in[0];
    
    // OR operation: at least one bit must be 1
    assign out_or  = in[3] | in[2] | in[1] | in[0];
    
    // XOR operation: odd number of bits must be 1
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule