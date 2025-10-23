module TopModule (
    input a,       // Don't-care input
    input b,       // Controls output when high
    input c,       // Controls output when high
    input d,       // Don't-care input
    output q       // Output is high when either b or c is high
);

    // Simple OR function - output is 1 if either b or c is 1
    assign q = b | c;

endmodule