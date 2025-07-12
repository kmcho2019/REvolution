module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND assignment for optimal power and area
    assign q = a & b;
endmodule