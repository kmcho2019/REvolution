module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Stage 1: For each of the 64 groups (256/4), select 4 bits among 4 inputs using sel[1:0]
    // Each group has 16 bits: 4 inputs * 4 bits each = 16 bits
    // We'll form a packed vector of 64 * 4 = 256 bits: concatenation of all selected 4-bit outputs

    wire [255:0] stage1_out; // 64 * 4 bits

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_stage1
            // Base index in 'in' for this group
            // Select 4 bits corresponding to sel[1:0]:
            // Offset: i*16 + sel[1:0]*4
            wire [3:0] selected_bits = in[(i*16) + (sel[1:0]*4) +: 4];
            assign stage1_out[i*4 +:4] = selected_bits;
        end
    endgenerate

    // Stage 2: Select among groups of 4 from stage1_out, controlled by sel[3:2]
    // stage1_out has 64 groups of 4 bits, form 16 groups of 4 stage1 outputs = 16 * 4 *4 bits = 256 bits
    // We'll create stage2_out of 16 * 4 bits = 64 bits

    wire [63:0] stage2_out;

    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_stage2
            // Each group: stage1_out indices i*4 to i*4+3, each 4 bits
            // Select one of 4 using sel[3:2]
            wire [15:0] group = {
                stage1_out[(i*16) + 12 +: 4], // index i*4+3 = (i*4+3)*4 = i*16 + 12
                stage1_out[(i*16) + 8  +: 4], // i*4+2
                stage1_out[(i*16) + 4  +: 4], // i*4+1
                stage1_out[(i*16) + 0  +: 4]  // i*4+0
            };
            wire [3:0] selected = group[sel[3:2]*4 +: 4];
            assign stage2_out[i*4 +:4] = selected;
        end
    endgenerate

    // Stage 3: 16 inputs at stage2_out, group into 4 groups of 4 inputs for next mux
    // stage3_out is 4 * 4 bits = 16 bits

    wire [15:0] stage3_out;

    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_stage3
            wire [15:0] group = {
                stage2_out[(i*16) + 12 +: 4], // i*4+3
                stage2_out[(i*16) + 8  +: 4], // i*4+2
                stage2_out[(i*16) + 4  +: 4], // i*4+1
                stage2_out[(i*16) + 0  +: 4]  // i*4+0
            };
            wire [3:0] selected = group[sel[5:4]*4 +: 4];
            assign stage3_out[i*4 +: 4] = selected;
        end
    endgenerate

    // Stage 4 (final): select among 4 stage3 outputs using sel[7:6]
    wire [15:0] group_final = {
        stage3_out[12 +: 4], // 3
        stage3_out[8  +: 4], // 2
        stage3_out[4  +: 4], // 1
        stage3_out[0  +: 4]  // 0
    };
    assign out = group_final[sel[7:6]*4 +: 4];

endmodule