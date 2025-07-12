module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct AND operation with continuous assignment
    assign q = a & b;
endmodule