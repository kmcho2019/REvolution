module TopModule (
    input  a,
    input  b,
    output q
);
    assign q = a & b;  // Optimal combinational AND implementation
endmodule