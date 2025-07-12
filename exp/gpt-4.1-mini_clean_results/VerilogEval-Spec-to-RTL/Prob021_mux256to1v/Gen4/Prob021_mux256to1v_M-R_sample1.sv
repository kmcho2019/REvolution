module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Directly select 4-bit slice using full sel as index
    // Each 4-bit segment is at in[(sel*4) +: 4]
    assign out = in[sel*4 +: 4];

endmodule