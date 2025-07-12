module TopModule (
    input  a,
    input  b,
    output out
);
    // Directly assign AND result to minimize hierarchy and optimize PPA
    assign out = a & b;
endmodule