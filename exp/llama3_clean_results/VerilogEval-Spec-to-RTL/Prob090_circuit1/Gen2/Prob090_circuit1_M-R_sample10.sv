module TopModule(
    input  a,
    input  b,
    output q
);

    assign q = a & b; // Using assign for continuous assignment

endmodule