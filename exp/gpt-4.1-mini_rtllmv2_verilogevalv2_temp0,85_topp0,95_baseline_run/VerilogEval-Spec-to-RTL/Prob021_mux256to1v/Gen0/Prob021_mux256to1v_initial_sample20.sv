module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Calculate the starting bit index for the selected 4-bit slice
    wire [9:0] start_bit = sel * 4;

    // Select the 4-bit output slice
    assign out = in[start_bit +: 4];

endmodule