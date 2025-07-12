module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire pair_xor;  // Indicates exactly one '1' in in[1:0]
    wire pair_and;  // Indicates both bits are '1'
    
    assign pair_xor = in[0] ^ in[1];
    assign pair_and = in[0] & in[1];
    
    // out[0]: odd parity of all bits = (in[2] XOR (in[0] XOR in[1]))
    assign out[0] = pair_xor ^ in[2];
    
    // out[1]: set if pair_and is set or if in[2] and pair_xor are both set (means total >=2)
    assign out[1] = pair_and | (pair_xor & in[2]);

endmodule