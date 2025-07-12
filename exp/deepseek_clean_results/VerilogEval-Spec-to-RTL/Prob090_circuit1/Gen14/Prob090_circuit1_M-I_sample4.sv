module TopModule (
    input a,
    input b,
    output q
);
    // Optimal AND gate implementation using continuous assignment
    assign q = a & b;
endmodule