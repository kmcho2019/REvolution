module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Output f is high when either:
    // 1) x3=0 and x2=1 (regardless of x1), or
    // 2) x3=1 and x1=1 (regardless of x2)
    assign f = (~x3 & x2) | (x3 & x1);

endmodule