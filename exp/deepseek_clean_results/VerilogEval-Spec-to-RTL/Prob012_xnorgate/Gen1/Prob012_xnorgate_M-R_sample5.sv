module TopModule (
    input a,
    input b,
    output out
);
    wire a_xor_b;
    assign a_xor_b = a ^ b;  // Intermediate XOR result
    assign out = ~a_xor_b;   // XNOR is the negation of XOR
endmodule