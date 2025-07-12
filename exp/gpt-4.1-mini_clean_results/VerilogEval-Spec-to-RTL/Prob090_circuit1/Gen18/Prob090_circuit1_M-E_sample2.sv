module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Implement AND via 2-to-1 MUX
    // q = b ? a : 0;
    // When b=0 -> q=0; when b=1 -> q=a
    assign q = b ? a : 1'b0;
endmodule