module TopModule (
    input  a,
    input  b,
    output q
);

    // Combinational logic using continuous assignment for optimal power, area, and performance
    assign q = a & b;

endmodule