module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Output f selects between x2 and x1 based on x3:
    // If x3=0, f = x2; if x3=1, f = x1
    assign f = x3 ? x1 : x2;

endmodule