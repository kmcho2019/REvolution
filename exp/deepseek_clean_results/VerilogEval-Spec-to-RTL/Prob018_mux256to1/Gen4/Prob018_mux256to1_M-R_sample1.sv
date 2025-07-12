module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Direct hierarchical selection
    assign out = in[(sel[7:4] * 16) + sel[3:0]];
endmodule