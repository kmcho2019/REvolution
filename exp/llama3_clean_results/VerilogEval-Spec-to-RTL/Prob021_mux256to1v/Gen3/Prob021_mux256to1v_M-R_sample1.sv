module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the start index of the 64-bit group
    wire [11:0] group_idx = {sel[7:4], 6'd0};

    // Calculate the start index of the 4-bit group within the 64-bit group
    wire [5:0] sub_group_idx = {sel[3:0], 2'd0};

    // Calculate the total start index of the 4-bit group within the 1024-bit input vector
    wire [11:0] start_idx = group_idx + sub_group_idx;

    // Assign the 4-bit output
    assign out = in[start_idx +: 4];

endmodule