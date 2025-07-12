module TopModule (
    input  a,
    input  b,
    output q
);
    // Direct AND gate for minimal area and power
    assign q = a & b;
endmodule