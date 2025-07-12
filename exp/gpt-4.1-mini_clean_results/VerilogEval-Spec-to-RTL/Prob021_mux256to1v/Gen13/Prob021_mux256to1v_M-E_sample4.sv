module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select
    output wire [3:0]    out   // 4-bit output
);

    // Calculate bit offset in the input bus for selected slice
    wire [9:0] offset;
    assign offset = sel * 4;

    // Select 4-bit slice starting at offset
    assign out = in[offset +: 4];

endmodule