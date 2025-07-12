module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND without hierarchical submodule for optimal PPA
    assign q = a & b;
endmodule