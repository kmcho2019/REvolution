module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Second level: Select between the 16 first-level outputs
    assign out = in[(sel[7:4]*64 + sel[3:0]*4) +: 4];
endmodule