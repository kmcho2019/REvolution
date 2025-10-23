module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the bit position based on the select line
    wire [11:0] start_bit = sel * 4;

    // Use the start bit position to extract the desired 4 bits from the input vector
    assign out = in[(start_bit + 3) : start_bit];

endmodule