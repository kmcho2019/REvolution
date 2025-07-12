module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the start index of the selected 4-bit value
    wire [9:0] start_idx = sel * 4;

    // Extract the selected 4-bit value from the input vector
    assign out = in[start_idx + 3 : start_idx];

endmodule