module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct AND implementation for optimal power and area
    assign q = a & b;
endmodule