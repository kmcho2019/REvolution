module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    assign min = (a < b) ? ((c < d) ? ((a < c) ? a : c) : ((a < d) ? a : d)) :
                           ((c < d) ? ((b < c) ? b : c) : ((b < d) ? b : d));

endmodule