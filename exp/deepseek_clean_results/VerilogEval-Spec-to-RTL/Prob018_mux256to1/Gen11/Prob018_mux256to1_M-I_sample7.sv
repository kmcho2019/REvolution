module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    // First stage: 16 parallel 16:1 muxes (one per group)
    wire [15:0] group_outputs;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_muxes
            assign group_outputs[i] = in[i*16 + sel[3:0]];
        end
    endgenerate

    // Second stage: 16:1 mux to select the correct group output
    assign out = group_outputs[sel[7:4]];

endmodule