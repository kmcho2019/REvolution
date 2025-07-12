module TopModule (
    input  a,
    input  b,
    output q
);
    assign q = a & b;  // Direct AND gate implementation using continuous assignment
endmodule