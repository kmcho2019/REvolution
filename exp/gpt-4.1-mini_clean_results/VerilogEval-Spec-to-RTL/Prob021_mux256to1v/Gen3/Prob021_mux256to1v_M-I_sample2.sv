module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Internal wires to hold intermediate mux outputs
    wire [3:0] stage1_out [15:0];

    // Each stage1_out[i] selects one of 16 4-bit inputs corresponding to sel[3:0]
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1_muxes
            // Each group has 16 segments: index j in [0..15]
            wire [3:0] inputs_16 [15:0];
            genvar j;
            for (j = 0; j < 16; j = j +1) begin : input_slices
                // Calculate index of 4-bit segment: group i * 16 + segment j
                // Each segment is 4 bits wide
                assign inputs_16[j] = in[4*((i*16)+j)+3 : 4*((i*16)+j)];
            end

            // 16-to-1 multiplexer controlled by sel[3:0]
            assign stage1_out[i] = inputs_16[sel[3:0]];
        end
    endgenerate

    // Final 16-to-1 multiplexer to select one of the 16 stage1 outputs using sel[7:4]
    assign out = stage1_out[sel[7:4]];

endmodule