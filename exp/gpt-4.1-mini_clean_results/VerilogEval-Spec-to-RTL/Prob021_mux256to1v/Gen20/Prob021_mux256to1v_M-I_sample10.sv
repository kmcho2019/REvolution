module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Calculate starting bit index for selection: sel * 4
    // Use part-select to extract 4 bits starting at sel*4
    assign out = in[sel*4 +: 4];
endmodule