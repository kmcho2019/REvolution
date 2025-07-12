module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate the starting bit index as sel << 2 (sel * 4)
    wire [9:0] start_bit = sel << 2;

    // Select the 4-bit segment directly from the input
    assign out = in[start_bit +: 4];

endmodule