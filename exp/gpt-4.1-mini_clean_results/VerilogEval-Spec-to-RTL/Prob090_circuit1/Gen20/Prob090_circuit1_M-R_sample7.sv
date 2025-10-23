module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational logic using assign statement
    assign q = a & b;
endmodule