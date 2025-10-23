module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Output f is a mux controlled by x3:
    // If x3=0, output f = x2
    // If x3=1, output f = x1
    assign f = x3 ? x1 : x2;

endmodule