module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Expression derived from truth table:
    // f = (x3 & x1) | (~x3 & x2);
    assign f = (x3 & x1) | (~x3 & x2);

endmodule