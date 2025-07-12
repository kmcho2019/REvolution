module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    assign q = (a | b) & (c | d);  // At least one from {a,b} AND at least one from {c,d}
endmodule