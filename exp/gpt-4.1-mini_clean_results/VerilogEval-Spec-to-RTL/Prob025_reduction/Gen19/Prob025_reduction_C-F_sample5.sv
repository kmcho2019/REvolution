module HalfXor(
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

module TopModule (
    input  [7:0] in,
    output       parity
);
    wire xor_reduce;
    assign xor_reduce = ^in; // built-in reduction XOR operator computes even parity

    // Use HalfXor module to generate parity output for modularity and clarity
    HalfXor hx (
        .a(1'b0),
        .b(xor_reduce),
        .y(parity)
    );
endmodule