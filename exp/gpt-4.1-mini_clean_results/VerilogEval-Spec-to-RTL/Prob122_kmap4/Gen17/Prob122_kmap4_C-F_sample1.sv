module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Output matches the given K-map pattern and is equivalent to the parity (XOR) of all inputs.
    // This minimal XOR reduction yields an efficient and clear implementation.
    assign out = a ^ b ^ c ^ d;

endmodule