module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Directly use the built-in operators for AND and OR
    assign out_and = in[3] & in[2] & in[1] & in[0];
    assign out_or  = in[3] | in[2] | in[1] | in[0];
    
    // Simplify the XOR gate implementation
    assign out_xor = (in[3] ^ in[2]) ^ (in[1] ^ in[0]);
endmodule