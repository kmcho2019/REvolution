module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Output q is high when either b or c is high,
    // independent of inputs a and d.
    // This minimizes logic and switching activity on q,
    // since changes in a or d do not affect q, helping power.
    assign q = b | c;
endmodule