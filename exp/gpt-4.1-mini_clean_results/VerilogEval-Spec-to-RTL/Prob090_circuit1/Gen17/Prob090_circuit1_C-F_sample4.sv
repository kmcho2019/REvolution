module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Combinational AND logic: q = a AND b
    assign q = a & b;
endmodule