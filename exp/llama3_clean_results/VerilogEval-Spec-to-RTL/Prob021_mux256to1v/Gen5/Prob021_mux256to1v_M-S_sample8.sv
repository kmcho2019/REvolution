module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index of the 4-bit group within the 1024-bit input vector
    wire [9:0] index = (sel[7:4] * 64) + (sel[3:0] * 4);

    // Extract the desired 4-bit output from the input vector
    assign out = in[index + 3 -: 4];

endmodule