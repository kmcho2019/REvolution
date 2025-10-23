module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);
    wire [15:0] level1_out;

    // Generate the 16 intermediate outputs by selecting one bit from each 16-bit chunk
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1_MUXES
            // Each level1_out[i] is selected from in[i*16 + sel[3:0]]
            assign level1_out[i] = in[i*16 + sel[3:0]];
        end
    endgenerate

    // Final output selects one of the 16 intermediate outputs based on sel[7:4]
    assign out = level1_out[sel[7:4]];
endmodule