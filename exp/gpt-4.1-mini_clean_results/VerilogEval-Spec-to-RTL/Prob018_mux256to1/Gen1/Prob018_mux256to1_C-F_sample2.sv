module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    // Level 0: 4-to-1 muxes selecting bits from 'in' based on sel[1:0]
    wire [63:0] level0;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_level0
            assign level0[i] = (sel[1:0] == 2'd0) ? in[i*4 + 0] :
                               (sel[1:0] == 2'd1) ? in[i*4 + 1] :
                               (sel[1:0] == 2'd2) ? in[i*4 + 2] :
                                                    in[i*4 + 3];
        end
    endgenerate

    // Level 1: 4-to-1 muxes selecting from level0 based on sel[3:2]
    wire [15:0] level1;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level1
            assign level1[i] = (sel[3:2] == 2'd0) ? level0[i*4 + 0] :
                               (sel[3:2] == 2'd1) ? level0[i*4 + 1] :
                               (sel[3:2] == 2'd2) ? level0[i*4 + 2] :
                                                   level0[i*4 + 3];
        end
    endgenerate

    // Level 2: 4-to-1 muxes selecting from level1 based on sel[5:4]
    wire [3:0] level2;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level2
            assign level2[i] = (sel[5:4] == 2'd0) ? level1[i*4 + 0] :
                               (sel[5:4] == 2'd1) ? level1[i*4 + 1] :
                               (sel[5:4] == 2'd2) ? level1[i*4 + 2] :
                                                   level1[i*4 + 3];
        end
    endgenerate

    // Level 3: single 4-to-1 mux selecting from level2 based on sel[7:6]
    assign out = (sel[7:6] == 2'd0) ? level2[0] :
                 (sel[7:6] == 2'd1) ? level2[1] :
                 (sel[7:6] == 2'd2) ? level2[2] :
                                      level2[3];

endmodule