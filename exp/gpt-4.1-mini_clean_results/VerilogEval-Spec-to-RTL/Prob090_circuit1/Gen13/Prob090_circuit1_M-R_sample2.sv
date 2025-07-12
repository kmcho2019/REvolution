module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational assignment implementing AND
    assign q = a & b;
endmodule