module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    wire [15:0] level1_outputs;
    wire [3:0] lower_sel = sel[3:0];
    wire [3:0] upper_sel = sel[7:4];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1_MUXES
            assign level1_outputs[i] = in[i*16 + lower_sel];
        end
    endgenerate

    assign out = level1_outputs[upper_sel];

endmodule