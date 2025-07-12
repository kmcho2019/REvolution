module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // 4-input AND gate (all bits high)
    assign out_and = in[3] & in[2] & in[1] & in[0];
    
    // 4-input OR gate (any bit high)
    assign out_or  = in[3] | in[2] | in[1] | in[0];
    
    // 4-input XOR gate (odd parity)
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];
endmodule