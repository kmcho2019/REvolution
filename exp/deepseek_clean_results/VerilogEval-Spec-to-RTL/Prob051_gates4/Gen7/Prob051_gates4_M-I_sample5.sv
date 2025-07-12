module TopModule (
    input [3:0] in,       // 4-bit input vector
    output out_and,       // 4-input AND: 1 when all inputs are 1
    output out_or,        // 4-input OR: 1 when any input is 1
    output out_xor        // 4-input XOR: 1 when odd number of inputs are 1
);

    // Using Verilog reduction operators for optimal implementation
    assign out_and = &in; // AND reduction (in[3] & in[2] & in[1] & in[0])
    assign out_or  = |in; // OR reduction (in[3] | in[2] | in[1] | in[0])
    assign out_xor = ^in; // XOR reduction (in[3] ^ in[2] ^ in[1] ^ in[0])

endmodule