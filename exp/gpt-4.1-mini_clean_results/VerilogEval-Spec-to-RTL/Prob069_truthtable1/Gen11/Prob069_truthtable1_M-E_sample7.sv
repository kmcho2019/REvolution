module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    wire term1, term2, term3, term4;

    assign term1 = (~x3) & x2 & (~x1);
    assign term2 = (~x3) & x2 & x1;
    assign term3 = x3 & (~x2) & x1;
    assign term4 = x3 & x2 & x1;

    assign f = term1 | term2 | term3 | term4;

endmodule