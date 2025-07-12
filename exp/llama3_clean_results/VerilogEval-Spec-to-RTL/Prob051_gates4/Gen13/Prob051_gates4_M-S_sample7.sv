module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Implement the 4-input AND gate using a tree-like structure
    assign out_and = in[3] & in[2] & in[1] & in[0];
    
    // Implement the 4-input OR gate using a tree-like structure
    assign out_or = in[3] | in[2] | in[1] | in[0];
    
    // Implement the 4-input XOR gate using a tree-like structure of 2-input XOR gates
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];
endmodule