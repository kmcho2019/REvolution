module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct assign for combinational AND functionality
    assign q = a & b;
endmodule