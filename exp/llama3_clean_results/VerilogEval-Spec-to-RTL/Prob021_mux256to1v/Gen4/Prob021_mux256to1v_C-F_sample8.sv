module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the index of the selected 64-bit chunk
    wire [6:0] chunk_index = sel[7:4];
    wire [63:0] chunk_out;

    // Select the correct 64-bit chunk from the input vector
    assign chunk_out = in[(chunk_index * 64) +: 64];

    // Calculate the index of the selected 4-bit group within the chunk
    wire [3:0] group_index = sel[3:0];

    // Select the correct 4-bit group from the selected chunk
    assign out = chunk_out[(group_index * 4) +: 4];

endmodule