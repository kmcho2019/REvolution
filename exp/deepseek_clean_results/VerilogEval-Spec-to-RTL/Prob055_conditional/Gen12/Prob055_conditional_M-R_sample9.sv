module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Find min of a and b, min of c and d, then min of those results
    assign min = ((a < b ? a : b) < (c < d ? c : d)) ? 
                 (a < b ? a : b) : 
                 (c < d ? c : d);

endmodule