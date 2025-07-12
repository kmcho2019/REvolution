module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First stage: 16 parallel 16-to-1 muxes
    wire [15:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_stage
            assign stage1_out[i] = in[i*16 + sel[3:0]];
        end
    endgenerate

    // Second stage: final 16-to-1 mux
    assign out = stage1_out[sel[7:4]];

endmodule