module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the start index of the 4-bit group based on the select input
    wire [9:0] start_idx = sel * 4;

    // Use a single level of multiplexers to select the desired 4-bit group
    assign out = in[start_idx +: 4];

endmodule