module TopModule (
    input  a,
    input  b,
    output q
);
    assign q = a & b;  // This remains the optimal implementation
endmodule