module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND assignment for optimal area and power
    assign q = a & b;
endmodule