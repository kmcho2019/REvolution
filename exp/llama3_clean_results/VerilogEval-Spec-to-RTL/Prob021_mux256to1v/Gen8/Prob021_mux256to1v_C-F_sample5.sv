module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index of the 64-bit group within the 1024-bit input vector
    wire [9:0] index_64 = (sel[7:4] * 64);

    // Extract the desired 64-bit group from the input vector
    wire [63:0] group_64 = in[index_64 + 63 -: 64];

    // Calculate the starting index of the 4-bit group within the 64-bit group
    wire [5:0] index_4 = (sel[3:0] * 4);

    // Extract the desired 4-bit output from the 64-bit group
    assign out = group_64[index_4 + 3 -: 4];

endmodule