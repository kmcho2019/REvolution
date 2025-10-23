module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Use shift instead of multiply for better PPA
    assign out = in[(sel << 2) +: 4];

endmodule