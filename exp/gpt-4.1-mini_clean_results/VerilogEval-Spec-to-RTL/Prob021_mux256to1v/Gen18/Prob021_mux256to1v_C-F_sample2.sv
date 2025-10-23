module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Direct arithmetic indexing selects 4 bits starting at sel*4
    assign out = in[sel*4 +: 4];
endmodule