// Top-level module implementing the 4-input AND, OR, and XOR gates
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Directly implement the 4-input AND gate using logical AND operator
    assign out_and = in[3] & in[2] & in[1] & in[0];
    
    // Directly implement the 4-input OR gate using logical OR operator
    assign out_or = in[3] | in[2] | in[1] | in[0];
    
    // Directly implement the 4-input XOR gate using logical XOR operator
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule