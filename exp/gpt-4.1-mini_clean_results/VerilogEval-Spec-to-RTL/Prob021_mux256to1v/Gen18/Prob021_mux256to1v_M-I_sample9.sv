module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Directly select 4 bits starting at sel*4 using indexed part-select
    assign out = in[sel*4 +: 4];

endmodule