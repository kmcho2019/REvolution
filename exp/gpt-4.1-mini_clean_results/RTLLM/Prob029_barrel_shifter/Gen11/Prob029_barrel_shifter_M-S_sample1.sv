module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage0_out, stage1_out;

    genvar i;

    // Stage 0: rotate by 4 bits if ctrl[2] is high
    generate
        for (i=0; i<8; i=i+1) begin : stage0
            assign stage0_out[i] = ctrl[2] ? in[(i+4)%8] : in[i];
        end
    endgenerate

    // Stage 1: rotate by 2 bits if ctrl[1] is high
    generate
        for (i=0; i<8; i=i+1) begin : stage1
            assign stage1_out[i] = ctrl[1] ? stage0_out[(i+2)%8] : stage0_out[i];
        end
    endgenerate

    // Stage 2: rotate by 1 bit if ctrl[0] is high
    generate
        for (i=0; i<8; i=i+1) begin : stage2
            assign out[i] = ctrl[0] ? stage1_out[(i+1)%8] : stage1_out[i];
        end
    endgenerate

endmodule