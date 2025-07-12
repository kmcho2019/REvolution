module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate start bit index of selected 4-bit segment
    wire [9:0] start_idx = sel << 2;  // sel * 4

    // Select 4 bits starting at start_idx
    assign out = in[start_idx +: 4];

endmodule