module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimized logic: out = a OR (NOT a AND NOT b AND c)
    assign out = a | (~a & ~b & c);
endmodule