module TopModule(
    input  a,
    input  b,
    output out
);
    wire xor_out;

    assign xor_out = a ^ b;   // XOR gate
    assign out = ~xor_out;    // NOT gate to get XNOR
endmodule