module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    wire [15:0] level1_out;

    genvar i;

    // First level: select bit from each 16-bit chunk using lower 4 bits of sel
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1_ASSIGN
            // Select bit in[chunk*16 + sel[3:0]]
            assign level1_out[i] = in[i*16 + sel[3:0]];
        end
    endgenerate

    // Second level: select one of the 16 bits using upper 4 bits of sel
    assign out = level1_out[sel[7:4]];
endmodule