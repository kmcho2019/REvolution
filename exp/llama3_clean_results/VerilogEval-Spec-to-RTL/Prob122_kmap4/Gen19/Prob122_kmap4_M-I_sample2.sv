module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Directly assign the XOR result to out, which is a concise and efficient way to implement the Karnaugh map logic.
    assign out = a ^ b ^ c ^ d;

endmodule