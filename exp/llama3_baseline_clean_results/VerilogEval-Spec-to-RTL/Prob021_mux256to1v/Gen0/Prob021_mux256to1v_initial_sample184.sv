module TopModule(
    input [1023:0] in,  // 1024-bit input vector
    input [7:0] sel,   // 8-bit select signal
    output [3:0] out   // 4-bit output
);

    // Calculate the start bit position based on the sel value
    wire [10:0] start_bit = sel * 4;

    // Use the start bit position to slice the input vector and assign the extracted 4-bit value to the output
    assign out = in[start_bit +: 4];

endmodule