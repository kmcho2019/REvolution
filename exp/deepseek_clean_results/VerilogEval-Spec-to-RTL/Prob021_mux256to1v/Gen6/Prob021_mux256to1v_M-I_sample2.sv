module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct 4-bit selection from 1024-bit input
    assign out = in[sel*4 +: 4];

endmodule