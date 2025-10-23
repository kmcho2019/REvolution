module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Calculate the offset within the input vector based on the most significant bits of the select signal
    wire [3:0] group_offset = sel[7:4];
    wire [3:0] bit_position = sel[3:0];

    // Calculate the absolute position of the bit to be selected within the 256-bit input vector
    wire [7:0] bit_index = {group_offset, bit_position};

    // Use the calculated index to select the desired bit from the input vector
    assign out = in[bit_index];

endmodule