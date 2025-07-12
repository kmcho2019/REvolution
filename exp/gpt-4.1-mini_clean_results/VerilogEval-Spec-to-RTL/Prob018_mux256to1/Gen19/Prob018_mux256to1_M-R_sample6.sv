module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Level 0: 64 outputs selecting 1 bit out of 4 from 'in' using sel[1:0]
    wire [63:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level0
            assign level0_out[i] = (sel[1:0] == 2'd0) ? in[i*4 + 0] :
                                  (sel[1:0] == 2'd1) ? in[i*4 + 1] :
                                  (sel[1:0] == 2'd2) ? in[i*4 + 2] :
                                                       in[i*4 + 3];
        end
    endgenerate

    // Level 1: 16 outputs selecting 1 bit out of 4 from level0_out using sel[3:2]
    wire [15:0] level1_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            assign level1_out[i] = (sel[3:2] == 2'd0) ? level0_out[i*4 + 0] :
                                  (sel[3:2] == 2'd1) ? level0_out[i*4 + 1] :
                                  (sel[3:2] == 2'd2) ? level0_out[i*4 + 2] :
                                                      level0_out[i*4 + 3];
        end
    endgenerate

    // Level 2: 4 outputs selecting 1 bit out of 4 from level1_out using sel[5:4]
    wire [3:0] level2_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2
            assign level2_out[i] = (sel[5:4] == 2'd0) ? level1_out[i*4 + 0] :
                                  (sel[5:4] == 2'd1) ? level1_out[i*4 + 1] :
                                  (sel[5:4] == 2'd2) ? level1_out[i*4 + 2] :
                                                      level1_out[i*4 + 3];
        end
    endgenerate

    // Level 3: final output selects 1 bit out of 4 from level2_out using sel[7:6]
    assign out = (sel[7:6] == 2'd0) ? level2_out[0] :
                 (sel[7:6] == 2'd1) ? level2_out[1] :
                 (sel[7:6] == 2'd2) ? level2_out[2] :
                                     level2_out[3];
endmodule