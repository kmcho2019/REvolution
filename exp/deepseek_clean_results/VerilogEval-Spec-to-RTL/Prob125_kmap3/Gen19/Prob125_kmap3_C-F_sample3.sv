module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map optimized logic: 
    // out = 1 when a=1 OR (a=0 AND b=0 AND c=1)
    assign out = a | (~a & ~b & c);
endmodule