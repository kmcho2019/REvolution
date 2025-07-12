module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // First stage: Select one of 16 groups of 16 bits
    wire [15:0] group_select [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group_select[i] = in[(i*16)+15:(i*16)];
        end
    endgenerate

    // Second stage: Use binary decoding within the selected group
    wire [3:0] group_sel = sel[7:4]; // Select which group
    wire [3:0] bit_sel = sel[3:0]; // Select which bit within the group
    wire [15:0] selected_group;
    assign selected_group = group_select[group_sel];

    // Binary decoding within the selected group
    wire [15:0] one_hot;
    assign one_hot = (1 << bit_sel);

    // Use the one-hot signal to select the desired bit from the selected group
    assign out = (selected_group & one_hot) != 0;

endmodule