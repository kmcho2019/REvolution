module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First level: Select one of 16 groups (16 bits each)
    wire [15:0] group_select;
    
    // Second level: Select one bit from the selected group
    wire [3:0] group_sel = sel[7:4];
    wire [3:0] bit_sel = sel[3:0];
    
    // Generate 16 intermediate 16:1 muxes
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_muxes
            assign group_select[i] = in[(i*16)+bit_sel];
        end
    endgenerate
    
    // Final 16:1 mux to select the correct group
    assign out = group_select[group_sel];

endmodule