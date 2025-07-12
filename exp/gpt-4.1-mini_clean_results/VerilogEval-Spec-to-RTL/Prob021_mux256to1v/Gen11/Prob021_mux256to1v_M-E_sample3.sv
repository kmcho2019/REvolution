module TopModule (
    input  wire [1023:0] in,   // 256 groups of 4 bits
    input  wire [7:0]    sel,  // select input
    output wire [3:0]    out
);
    // One-hot decode sel to 256 bits
    wire [255:0] sel_onehot = 1 << sel;

    // Break input into 256 4-bit vectors
    wire [3:0] inputs_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : INPUT_SPLIT
            assign inputs_array[i] = in[4*i +: 4];
        end
    endgenerate

    // Mask each 4-bit input with its one-hot select bit (zero or input)
    wire [3:0] masked [0:255];
    generate
        for (i = 0; i < 256; i = i + 1) begin : MASK
            assign masked[i] = sel_onehot[i] ? inputs_array[i] : 4'b0000;
        end
    endgenerate

    // Reduce all masked 4-bit inputs with bitwise OR to get final output
    // Use a reduction tree for OR to avoid huge fanin
    // Stage 1: 64 groups of OR4
    wire [3:0] or_stage1 [0:63];
    generate
        for (i = 0; i < 64; i = i + 1) begin : OR_STAGE1
            assign or_stage1[i] = masked[4*i] | masked[4*i+1] | masked[4*i+2] | masked[4*i+3];
        end
    endgenerate

    // Stage 2: 16 groups of OR4
    wire [3:0] or_stage2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : OR_STAGE2
            assign or_stage2[i] = or_stage1[4*i] | or_stage1[4*i+1] | or_stage1[4*i+2] | or_stage1[4*i+3];
        end
    endgenerate

    // Stage 3: 4 groups of OR4
    wire [3:0] or_stage3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : OR_STAGE3
            assign or_stage3[i] = or_stage2[4*i] | or_stage2[4*i+1] | or_stage2[4*i+2] | or_stage2[4*i+3];
        end
    endgenerate

    // Stage 4: Final OR4
    assign out = or_stage3[0] | or_stage3[1] | or_stage3[2] | or_stage3[3];
endmodule