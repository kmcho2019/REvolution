module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [63:0] group_out;

    // Calculate the start index of the selected 64-bit group
    wire [9:0] group_start = {4'd0, sel[7:4]} * 64;

    // Select the 64-bit group from the input vector
    assign group_out = in[(group_start + 63) : group_start];

    // Calculate the start index of the selected 4-bit group within the 64-bit group
    wire [5:0] word_start = sel[3:0] * 4;

    // Select the 4-bit output from the selected 64-bit group
    assign out = group_out[(word_start + 3) : word_start];

endmodule