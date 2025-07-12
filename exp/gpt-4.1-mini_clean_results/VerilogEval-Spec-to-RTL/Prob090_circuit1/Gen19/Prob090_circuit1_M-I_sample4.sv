module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct AND implementation for better PPA
    assign q = a & b;
endmodule