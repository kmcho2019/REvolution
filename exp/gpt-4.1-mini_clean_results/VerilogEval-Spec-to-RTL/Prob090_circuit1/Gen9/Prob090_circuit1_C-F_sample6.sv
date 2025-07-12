module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Implement combinational AND directly with continuous assignment
    assign q = a & b;
endmodule