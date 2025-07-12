module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct AND assignment for optimal performance, power, and area
    assign q = a & b;
endmodule