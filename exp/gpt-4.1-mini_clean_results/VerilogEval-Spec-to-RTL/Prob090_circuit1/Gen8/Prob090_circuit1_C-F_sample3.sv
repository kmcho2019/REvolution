module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational assignment using AND operator
    assign q = a & b;
endmodule