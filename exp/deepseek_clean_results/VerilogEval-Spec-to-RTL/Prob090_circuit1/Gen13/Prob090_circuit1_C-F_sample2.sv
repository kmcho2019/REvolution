module TopModule (
    input  a,
    input  b,
    output q
);
    assign q = a & b;  // Optimal AND gate implementation
endmodule