module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First stage: 16 groups of 16:1 muxes
    wire [15:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1_muxes
            assign stage1_out[i] = in[(i*16) + sel[3:0]];
        end
    endgenerate

    // Second stage: 16:1 mux to select final output
    assign out = stage1_out[sel[7:4]];

endmodule