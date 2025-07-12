module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal implementation: q is true when (a OR b) AND (c OR d)
    // This matches all cases in the truth table with minimal logic
    assign q = (a | b) & (c | d);
endmodule