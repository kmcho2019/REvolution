module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Calculate the group and bit position within the group
    wire [3:0] group_sel = sel[7:4]; // Select which group
    wire [3:0] bit_sel = sel[3:0]; // Select which bit within the group

    // Calculate the bit position within the input vector
    wire [7:0] bit_position = (group_sel * 16) + bit_sel;

    // Use the bit position to select the desired bit from the input vector
    assign out = in[bit_position];

endmodule