module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Output q is high when b or c is high, independent of a or d.
    assign q = b | c;

endmodule