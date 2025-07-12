module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the 8-bit select signal into two parts: group and bit selection
    wire [3:0] group_sel = sel[7:4];
    wire [3:0] bit_sel = sel[3:0];

    // Use a binary decoder to select the desired group
    wire [15:0] group [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group[i] = in[(i*16)+15:(i*16)];
        end
    endgenerate

    // Use a binary decoder to select the desired bit within the group
    wire [15:0] selected_group;
    assign selected_group = group[group_sel];

    // Final selection using a binary decoder
    assign out = selected_group[bit_sel];

    // Optional: Use clock gating or power-efficient encoding schemes to reduce switching activity
    // For example:
    // wire clock_gated_sel;
    // assign clock_gated_sel = sel & clock;
    // Use clock_gated_sel instead of sel in the design

endmodule