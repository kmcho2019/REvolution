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
            assign group[i] = in[(i*16)+15:(i*8)]; // Corrected the bit assignment
        end
    endgenerate

    // Hierarchical selection process
    wire [3:0] group_sel = sel[7:4]; // Select which group
    wire [3:0] bit_sel = sel[3:0]; // Select which bit within the group

    // Select one bit from the chosen group
    wire [15:0] selected_group;
    assign selected_group = group[group_sel];

    // Final selection with optimized logic
    assign out = selected_group[bit_sel];

    // Additional optimization: consider using a clock gate for the selection logic
    // This can help reduce power consumption by minimizing switching activity
    // However, this would require a clock signal to be added to the module

endmodule