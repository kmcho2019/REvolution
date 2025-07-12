module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Cascaded comparison: (((a < b ? a : b) < c) ? ... ) < d ? ... : d
    assign min = (((a < b) ? a : b) < c ? ((a < b) ? a : b) : c) < d ? 
                 (((a < b) ? a : b) < c ? ((a < b) ? a : b) : c) : d;

endmodule