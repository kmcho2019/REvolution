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

    // Hierarchical selection process
    wire [3:0] group_sel = sel[7:4]; // Select which group
    wire [3:0] bit_sel = sel[3:0]; // Select which bit within the group

    // Select one bit from the chosen group using direct selection
    assign out = group[group_sel][bit_sel];

endmodule