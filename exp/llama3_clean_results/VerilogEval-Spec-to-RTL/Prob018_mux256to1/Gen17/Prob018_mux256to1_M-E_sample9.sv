module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Level 1: 128 2-to-1 multiplexers
    wire [127:0] level1_out;
    genvar i;
    generate
        for (i = 0; i < 128; i++) begin
            assign level1_out[i] = (sel[7] == 0) ? in[i*2] : in[i*2 + 1];
        end
    endgenerate

    // Level 2: 64 2-to-1 multiplexers
    wire [63:0] level2_out;
    generate
        for (i = 0; i < 64; i++) begin
            assign level2_out[i] = (sel[6] == 0) ? level1_out[i*2] : level1_out[i*2 + 1];
        end
    endgenerate

    // Level 3: 32 2-to-1 multiplexers
    wire [31:0] level3_out;
    generate
        for (i = 0; i < 32; i++) begin
            assign level3_out[i] = (sel[5] == 0) ? level2_out[i*2] : level2_out[i*2 + 1];
        end
    endgenerate

    // Level 4: 16 2-to-1 multiplexers
    wire [15:0] level4_out;
    generate
        for (i = 0; i < 16; i++) begin
            assign level4_out[i] = (sel[4] == 0) ? level3_out[i*2] : level3_out[i*2 + 1];
        end
    endgenerate

    // Level 5: 8 2-to-1 multiplexers
    wire [7:0] level5_out;
    generate
        for (i = 0; i < 8; i++) begin
            assign level5_out[i] = (sel[3] == 0) ? level4_out[i*2] : level4_out[i*2 + 1];
        end
    endgenerate

    // Level 6: 4 2-to-1 multiplexers
    wire [3:0] level6_out;
    generate
        for (i = 0; i < 4; i++) begin
            assign level6_out[i] = (sel[2] == 0) ? level5_out[i*2] : level5_out[i*2 + 1];
        end
    endgenerate

    // Level 7: 2 2-to-1 multiplexers
    wire [1:0] level7_out;
    generate
        for (i = 0; i < 2; i++) begin
            assign level7_out[i] = (sel[1] == 0) ? level6_out[i*2] : level6_out[i*2 + 1];
        end
    endgenerate

    // Final 2-to-1 multiplexer
    assign out = (sel[0] == 0) ? level7_out[0] : level7_out[1];

endmodule