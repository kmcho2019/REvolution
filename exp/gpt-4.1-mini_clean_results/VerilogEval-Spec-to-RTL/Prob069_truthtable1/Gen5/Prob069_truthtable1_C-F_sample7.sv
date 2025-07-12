module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Output f is high when:
    // - x3 is 0 and x2 is 1
    // - or x3 is 1 and x1 is 1
    // Truth table mapping: f = (~x3 & x2) | (x3 & x1)
    assign f = (~x3 & x2) | (x3 & x1);

endmodule