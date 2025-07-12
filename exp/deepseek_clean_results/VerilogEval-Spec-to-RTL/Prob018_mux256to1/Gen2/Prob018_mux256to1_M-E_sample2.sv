module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // First level: 16x 16-to-1 muxes
    wire [15:0] first_level_out;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_level
            assign first_level_out[i] = in[(i*16) + sel[3:0]];
        end
    endgenerate

    // Second level: 16-to-1 mux
    assign out = first_level_out[sel[7:4]];
endmodule