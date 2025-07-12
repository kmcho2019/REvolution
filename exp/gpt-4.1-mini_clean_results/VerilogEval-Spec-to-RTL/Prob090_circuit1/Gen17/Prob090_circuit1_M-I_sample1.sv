module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND implementation
    assign q = a & b;
endmodule