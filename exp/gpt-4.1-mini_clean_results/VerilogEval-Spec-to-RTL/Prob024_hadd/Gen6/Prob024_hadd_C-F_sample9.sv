module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);
    // Internally instantiate primitives but expose outputs via continuous assign for clarity
    wire xor_out, and_out;

    xor xor_gate(xor_out, a, b);
    and and_gate(and_out, a, b);

    assign sum = xor_out;
    assign cout = and_out;
endmodule