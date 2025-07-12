module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index of the selected input
    wire [9:0] start_idx = sel * 4;

    // Assign the selected input to the output
    assign out = in[start_idx + 3 : start_idx];

endmodule