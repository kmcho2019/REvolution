module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the input vector into pairs of bits
    wire [1:0] pair [127:0];
    genvar i;
    generate
        for (i = 0; i < 128; i++) begin
            assign pair[i] = in[(i*2)+1:(i*2)];
        end
    endgenerate

    // Stage 1: Select one of two bits in each pair using the least significant bit of the select signal
    wire [127:0] stage1_out;
    genvar j;
    generate
        for (j = 0; j < 128; j++) begin
            assign stage1_out[j] = (sel[0]) ? pair[j][1] : pair[j][0];
        end
    endgenerate

    // Stage 2: Select one of two bits in each pair using the next bit of the select signal
    wire [63:0] stage2_out;
    genvar k;
    generate
        for (k = 0; k < 64; k++) begin
            assign stage2_out[k] = (sel[1]) ? stage1_out[(k*2)+1] : stage1_out[k*2];
        end
    endgenerate

    // Stage 3: Select one of two bits in each pair using the next bit of the select signal
    wire [31:0] stage3_out;
    genvar l;
    generate
        for (l = 0; l < 32; l++) begin
            assign stage3_out[l] = (sel[2]) ? stage2_out[(l*2)+1] : stage2_out[l*2];
        end
    endgenerate

    // Stage 4: Select one of two bits in each pair using the next bit of the select signal
    wire [15:0] stage4_out;
    genvar m;
    generate
        for (m = 0; m < 16; m++) begin
            assign stage4_out[m] = (sel[3]) ? stage3_out[(m*2)+1] : stage3_out[m*2];
        end
    endgenerate

    // Stage 5: Select one of two bits in each pair using the next bit of the select signal
    wire [7:0] stage5_out;
    genvar n;
    generate
        for (n = 0; n < 8; n++) begin
            assign stage5_out[n] = (sel[4]) ? stage4_out[(n*2)+1] : stage4_out[n*2];
        end
    endgenerate

    // Stage 6: Select one of two bits in each pair using the next bit of the select signal
    wire [3:0] stage6_out;
    genvar o;
    generate
        for (o = 0; o < 4; o++) begin
            assign stage6_out[o] = (sel[5]) ? stage5_out[(o*2)+1] : stage5_out[o*2];
        end
    endgenerate

    // Stage 7: Select one of two bits in each pair using the next bit of the select signal
    wire [1:0] stage7_out;
    genvar p;
    generate
        for (p = 0; p < 2; p++) begin
            assign stage7_out[p] = (sel[6]) ? stage6_out[(p*2)+1] : stage6_out[p*2];
        end
    endgenerate

    // Stage 8: Select the final bit using the most significant bit of the select signal
    assign out = (sel[7]) ? stage7_out[1] : stage7_out[0];

endmodule