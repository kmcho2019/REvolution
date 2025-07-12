module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Output is 0 only when all inputs are 0 (a=0, b=0, c=0)
    // From K-map: out = a + b + c (OR of all inputs)
    assign out = a | b | c;
endmodule