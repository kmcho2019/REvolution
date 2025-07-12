module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the base index of the selected group
    wire [9:0] base_index = sel * 4;

    // Extract the correct 4-bit group from the input vector
    assign out = in[base_index + 3 : base_index];

endmodule