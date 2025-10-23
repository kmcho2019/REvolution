module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct AND implementation for minimal gate count and power
    assign q = a & b;
endmodule