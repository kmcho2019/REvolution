module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    wire [15:0] mux_level1; // outputs of 16 16-to-1 muxes

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1_muxes
            // Each 16-to-1 mux selects one bit from in[i*16 + 0 to 15] based on sel[3:0]
            assign mux_level1[i] = in[i*16 + sel[3:0]];
        end
    endgenerate

    // Final 16-to-1 mux selects one bit from mux_level1 based on sel[7:4]
    assign out = mux_level1[sel[7:4]];

endmodule