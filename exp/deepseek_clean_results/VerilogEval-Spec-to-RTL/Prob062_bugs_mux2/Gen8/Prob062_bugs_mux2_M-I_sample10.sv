module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Bitwise implementation that might optimize better for area
    assign out = (a & {8{~sel}}) | (b & {8{sel}});

endmodule