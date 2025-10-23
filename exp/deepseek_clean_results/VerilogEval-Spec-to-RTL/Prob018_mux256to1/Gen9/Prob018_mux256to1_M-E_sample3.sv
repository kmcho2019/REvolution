module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Stage 1: 16 groups of 16 inputs each
    wire [15:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            assign stage1_out[i] = in[i*16 + sel[3:0]];
        end
    endgenerate

    // Stage 2: Final 16-to-1 mux
    assign out = stage1_out[sel[7:4]];

endmodule