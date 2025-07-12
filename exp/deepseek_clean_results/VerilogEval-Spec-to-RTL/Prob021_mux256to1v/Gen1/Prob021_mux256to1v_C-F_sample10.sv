module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Use shift instead of multiply for better hardware efficiency
    // sel << 2 is equivalent to sel * 4
    assign out = in[(sel << 2) +: 4];

endmodule