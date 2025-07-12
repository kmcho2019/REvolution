module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Minimal flat combinational AND logic implemented via continuous assignment
    assign q = a & b;
endmodule