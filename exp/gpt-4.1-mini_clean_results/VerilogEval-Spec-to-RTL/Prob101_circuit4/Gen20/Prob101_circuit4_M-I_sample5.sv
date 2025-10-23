module TopModule(
    input a, // unused input
    input b,
    input c,
    input d, // unused input
    output q
);
    // Output q is high if either b or c is high.
    assign q = b | c;
endmodule