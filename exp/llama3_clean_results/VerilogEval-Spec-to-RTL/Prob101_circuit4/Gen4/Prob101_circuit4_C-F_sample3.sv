module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Direct and simplified implementation of the required logic
assign q = (b || c) || (a && (b || c));

endmodule