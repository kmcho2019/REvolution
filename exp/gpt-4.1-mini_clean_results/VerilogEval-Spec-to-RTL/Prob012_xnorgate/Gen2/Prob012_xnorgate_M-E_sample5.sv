module TopModule (
    input a,
    input b,
    output out
);
    wire xor_out;

    // XOR operation
    assign xor_out = a ^ b;

    // NOT operation to get XNOR
    assign out = ~xor_out;

endmodule