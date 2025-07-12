module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: rotate by 4 bits if ctrl[2] == 1
    wire [7:0] stage4;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage4
            assign stage4[i] = ctrl[2] ? in[(i + 4) % 8] : in[i];
        end
    endgenerate

    // Stage 2: rotate by 2 bits if ctrl[1] == 1
    wire [7:0] stage2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage2
            assign stage2[i] = ctrl[1] ? stage4[(i + 2) % 8] : stage4[i];
        end
    endgenerate

    // Stage 3: rotate by 1 bit if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage1
            assign out[i] = ctrl[0] ? stage2[(i + 1) % 8] : stage2[i];
        end
    endgenerate

endmodule