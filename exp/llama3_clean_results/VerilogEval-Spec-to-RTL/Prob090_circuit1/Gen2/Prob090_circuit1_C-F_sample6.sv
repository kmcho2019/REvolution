module TopModule(
    input  a,
    input  b,
    output q
);
    // Direct and efficient implementation of an AND gate
    assign q = a & b;
endmodule