module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct AND operation with continuous assignment for minimal logic and hierarchy
    assign out = a & b;
endmodule