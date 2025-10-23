module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    wire xor_out;

    // First, compute XOR of inputs
    xor (xor_out, a, b);
    // Then, invert XOR output to get XNOR
    not (out, xor_out);
endmodule