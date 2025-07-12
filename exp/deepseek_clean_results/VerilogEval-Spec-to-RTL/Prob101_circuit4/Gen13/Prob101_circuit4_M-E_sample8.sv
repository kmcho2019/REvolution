module TopModule (
    input  a, b, c, d,
    output q
);
    // Priority encoder with active-low enable
    assign q = ~a & (b ? 1'b1 : c);
endmodule