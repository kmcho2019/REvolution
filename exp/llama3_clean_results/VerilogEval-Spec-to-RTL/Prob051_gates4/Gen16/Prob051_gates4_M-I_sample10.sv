// Define the TopModule with optimized 4-input gates
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Optimized 4-input AND gate using a balanced tree structure
    assign out_and = (in[3] & in[2]) & (in[1] & in[0]);

    // Optimized 4-input OR gate using a balanced tree structure
    assign out_or = (in[3] | in[2]) | (in[1] | in[0]);

    // Optimized 4-input XOR gate using a combination of AND, OR, and NOT gates
    assign out_xor = ((in[3] ^ in[2]) ^ in[1]) ^ in[0];

    // Alternatively, for the XOR gate, leveraging a power-efficient implementation
    // assign out_xor = ((in[3] & ~in[2]) | (~in[3] & in[2])) ^ (in[1] ^ in[0]);
endmodule