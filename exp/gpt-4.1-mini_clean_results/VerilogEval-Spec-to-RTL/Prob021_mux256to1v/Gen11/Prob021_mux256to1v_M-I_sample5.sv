module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Direct indexed part-select based on sel
    assign out = in[sel*4 +: 4];

endmodule