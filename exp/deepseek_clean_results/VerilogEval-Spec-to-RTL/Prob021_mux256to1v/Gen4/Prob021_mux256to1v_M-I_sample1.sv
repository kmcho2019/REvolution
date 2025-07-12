module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Single-level selection using direct bit calculation
    assign out = in[(sel * 4) +: 4];

endmodule