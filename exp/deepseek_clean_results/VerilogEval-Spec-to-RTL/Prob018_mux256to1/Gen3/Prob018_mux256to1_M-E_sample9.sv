module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Intermediate 16-bit buses from first level muxes
    wire [15:0] mux_stage [15:0];
    
    // First level: 16 groups of 16 bits
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_level
            assign mux_stage[i] = in[(i*16)+15 : i*16];
        end
    endgenerate
    
    // Second level: Select one bit from the selected group
    wire [15:0] selected_group = mux_stage[sel[7:4]];
    assign out = selected_group[sel[3:0]];

endmodule