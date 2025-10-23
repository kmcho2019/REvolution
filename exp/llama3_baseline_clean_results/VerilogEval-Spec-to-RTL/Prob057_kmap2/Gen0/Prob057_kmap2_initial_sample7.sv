module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (a & ~b & ~c) | (~a & ~c & d) | (~a & b & c) | (~a & b & ~d) | (a & b & d) | (a & ~b & d) | (~a & b & ~c & d) | (a & b & ~c & d);

    // Alternatively, simplification might yield a more compact expression
    // assign out = (~a & ~c & d) | (a & ~c) | (~a & b & c) | (a & b & d);

    // However, direct translation from Karnaugh map often results in more straightforward but longer expressions.
    // Hence the above simplified form might be used for efficiency but may require additional steps of Karnaugh simplification.

endmodule