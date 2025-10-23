module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the start index of the desired 4-bit group
    wire [9:0] start_idx = (sel[7:4] * 64) + (sel[3:0] * 4);

    // Select the 4-bit group from the input vector
    assign out = in[start_idx +: 4];

endmodule