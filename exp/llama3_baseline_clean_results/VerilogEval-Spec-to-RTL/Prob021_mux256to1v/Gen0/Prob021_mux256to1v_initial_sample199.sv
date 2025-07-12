module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the start index of the selected input
    wire [9:0] start_index = {2'b0, sel} * 4;

    // Extract the selected 4-bit input from the 1024-bit vector
    assign out = in[start_index + 3 : start_index];

endmodule