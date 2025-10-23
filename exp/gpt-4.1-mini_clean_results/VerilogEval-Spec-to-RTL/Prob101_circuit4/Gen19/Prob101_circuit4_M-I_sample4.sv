module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Output is high if either b or c is high, regardless of a and d
    assign q = b | c;
endmodule