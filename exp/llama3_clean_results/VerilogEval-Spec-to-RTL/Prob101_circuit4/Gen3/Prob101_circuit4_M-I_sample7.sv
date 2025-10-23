module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// The expression is already optimized for the described functionality.
// However, to further optimize for PPA, consider the input patterns and synthesis tool capabilities.
assign q = (b || c) || (a && (b || c));

endmodule