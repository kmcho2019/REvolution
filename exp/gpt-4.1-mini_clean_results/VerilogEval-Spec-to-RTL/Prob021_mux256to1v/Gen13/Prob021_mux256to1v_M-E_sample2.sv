module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate bit offset for the selected 4-bit slice
    wire [9:0] bit_offset = sel << 2; // sel * 4

    // Use indexed part-select to extract selected 4-bit input
    assign out = in[bit_offset +: 4];
endmodule