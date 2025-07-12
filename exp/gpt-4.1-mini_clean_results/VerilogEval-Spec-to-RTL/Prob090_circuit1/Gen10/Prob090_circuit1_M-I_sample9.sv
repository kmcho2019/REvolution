module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND assignment for minimal logic and resource usage
    assign q = a & b;
endmodule