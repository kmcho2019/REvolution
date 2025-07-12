module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    wire [15:0] group [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group[i] = in[(i*16)+15:(i*16)];
        end
    endgenerate

    // Decode one of 16 possible groups using the higher 4 bits of the select signal
    wire [3:0] group_sel = sel[7:4];
    wire [15:0] selected_group;
    assign selected_group = group[group_sel];

    // Create a mask signal to select one bit from the chosen group
    wire [3:0] bit_sel = sel[3:0];
    wire [15:0] mask;
    always_comb begin
        mask = 16'b0;
        mask[bit_sel] = 1'b1;
    end

    // Use the mask signal to select the desired bit
    assign out = (selected_group & mask)[0];

endmodule