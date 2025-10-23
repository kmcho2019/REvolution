module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Direct 4-bit selection from 256 possible locations
    // Equivalent to: out = in[sel*4 +: 4] but more explicit
    assign out = in[(sel << 2) +: 4];  // sel*4 = sel << 2
endmodule