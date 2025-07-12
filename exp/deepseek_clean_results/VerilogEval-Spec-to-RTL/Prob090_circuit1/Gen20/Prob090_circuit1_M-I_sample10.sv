module TopModule (
    input  a,
    input  b,
    output q
);
    // Simple AND gate implementation (already optimal)
    assign q = a & b;
endmodule