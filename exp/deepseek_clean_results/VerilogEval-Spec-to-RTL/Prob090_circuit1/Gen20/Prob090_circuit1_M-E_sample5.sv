module TopModule (
    input  a,
    input  b,
    output q
);
    // Implement AND function using a 4-to-1 mux
    // Select lines: {a, b}
    // Data inputs: 0, 0, 0, 1 (for 00, 01, 10, 11 cases respectively)
    assign q = (a & b) ? 1'b1 : 1'b0;
endmodule