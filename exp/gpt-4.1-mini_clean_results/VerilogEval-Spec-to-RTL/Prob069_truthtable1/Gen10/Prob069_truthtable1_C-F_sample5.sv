module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Function f based on truth table:
    // f = (x3 & x1) | (~x3 & x2)
    // This is equivalent to a 2-to-1 mux selecting between x2 and x1 with select x3.
    assign f = x3 ? x1 : x2;

endmodule