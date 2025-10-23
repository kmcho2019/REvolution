module TopModule (
    input  a,
    input  b,
    output q
);
    // Using continuous assignment for optimal synthesis
    assign q = a & b;
endmodule