module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // First stage: 64 groups of 4 bits, each group is a 4-bit input
    wire [3:0] first_stage [0:63];

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : unpack_4bit_inputs
            assign first_stage[i] = in[i*4 +: 4];
        end
    endgenerate

    // Second stage: 16 groups of 4 bits, each group selects among 16 first_stage inputs
    wire [3:0] second_stage [0:15];
    genvar j, k;
    generate
        for (j = 0; j < 16; j = j + 1) begin : second_stage_muxes
            wire [3:0] mux_inputs [0:15];
            for (k = 0; k < 16; k = k + 1) begin : assign_mux_inputs
                assign mux_inputs[k] = first_stage[j*16 + k];
            end

            // 16-to-1 mux for each of 16 groups, selected by sel[3:0]
            assign second_stage[j] = mux_inputs[sel[3:0]];
        end
    endgenerate

    // Final stage: 16-to-1 mux on second_stage outputs, selected by sel[7:4]
    wire [3:0] final_inputs [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : final_stage_assign
            assign final_inputs[i] = second_stage[i];
        end
    endgenerate

    assign out = final_inputs[sel[7:4]];

endmodule