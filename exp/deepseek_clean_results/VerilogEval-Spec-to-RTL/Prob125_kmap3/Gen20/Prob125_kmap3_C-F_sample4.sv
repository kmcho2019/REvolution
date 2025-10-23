module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map optimized logic (d=don't-care):
    // out = 1 when either:
    //   a is 1 (top rows), OR
    //   a=0 AND b=0 AND c=1 (left-middle cell)
    assign out = a | (~a & ~b & c);
endmodule