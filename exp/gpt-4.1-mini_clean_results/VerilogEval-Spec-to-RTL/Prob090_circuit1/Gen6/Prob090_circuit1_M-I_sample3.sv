module TopModule (
    input  a,
    input  b,
    output q
);
    // Combinational logic implemented using continuous assignment:
    assign q = a & b;
endmodule