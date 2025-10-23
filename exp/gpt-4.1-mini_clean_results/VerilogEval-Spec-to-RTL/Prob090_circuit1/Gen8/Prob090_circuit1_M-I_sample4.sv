module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND assignment without extra module instantiation
    assign q = a & b;
endmodule