module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND operation
    assign q = a & b;
endmodule