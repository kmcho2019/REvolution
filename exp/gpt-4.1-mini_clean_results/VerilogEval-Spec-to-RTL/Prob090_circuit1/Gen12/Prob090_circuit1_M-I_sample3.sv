module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND assignment for optimal synthesis
    assign q = a & b;
endmodule