module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND assignment for minimal hierarchy and optimal PPA
    assign q = a & b;
endmodule