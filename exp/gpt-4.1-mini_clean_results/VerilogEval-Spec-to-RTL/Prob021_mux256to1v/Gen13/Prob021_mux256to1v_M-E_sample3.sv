module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Calculate the bit offset by multiplying sel by 4
    // Use a variable part-select starting at sel*4 and 4 bits wide
    assign out = in[sel*4 +: 4];
endmodule