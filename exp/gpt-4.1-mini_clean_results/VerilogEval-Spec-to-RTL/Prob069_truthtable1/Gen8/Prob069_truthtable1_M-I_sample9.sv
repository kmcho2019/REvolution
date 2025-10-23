module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Implement f as a 2:1 mux selecting x1 when x3=1 else x2
    assign f = x3 ? x1 : x2;

endmodule