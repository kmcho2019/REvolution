module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct AND operation using assign
    assign q = a & b;
endmodule