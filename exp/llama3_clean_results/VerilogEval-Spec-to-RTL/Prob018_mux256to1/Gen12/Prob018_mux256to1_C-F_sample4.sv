module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the input vector into 16 groups of 16 bits
    wire [15:0] group [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group[i] = in[(i*16)+15:(i*16)];
        end
    endgenerate

    // Select one of the 16 groups using the most significant 4 bits of the select signal
    wire [3:0] group_sel = sel[7:4];
    wire [15:0] selected_group;
    assign selected_group = group[group_sel];

    // Select one bit from the chosen group using the least significant 4 bits of the select signal
    wire [3:0] bit_sel = sel[3:0];
    assign out = selected_group[bit_sel];

endmodule