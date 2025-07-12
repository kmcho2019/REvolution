module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Generate one-hot select signal from sel
    wire [255:0] one_hot;
    assign one_hot = 256'b1 << sel;

    // Mask input with one-hot signal
    wire [255:0] masked_in = in & one_hot;

    // OR reduction implemented as balanced binary tree for clarity
    // Levelwise reduction signals
    wire [127:0] or_level1;
    wire [63:0]  or_level2;
    wire [31:0]  or_level3;
    wire [15:0]  or_level4;
    wire [7:0]   or_level5;
    wire [3:0]   or_level6;
    wire [1:0]   or_level7;
    wire         or_level8;

    genvar i;
    // Level 1: OR pairs of bits from masked_in to get 128 bits
    generate
        for (i = 0; i < 128; i = i + 1) begin : or_l1
            assign or_level1[i] = masked_in[2*i] | masked_in[2*i+1];
        end
    endgenerate

    // Level 2: OR pairs of bits from or_level1 to get 64 bits
    generate
        for (i = 0; i < 64; i = i + 1) begin : or_l2
            assign or_level2[i] = or_level1[2*i] | or_level1[2*i+1];
        end
    endgenerate

    // Level 3: 32 bits
    generate
        for (i = 0; i < 32; i = i + 1) begin : or_l3
            assign or_level3[i] = or_level2[2*i] | or_level2[2*i+1];
        end
    endgenerate

    // Level 4: 16 bits
    generate
        for (i = 0; i < 16; i = i + 1) begin : or_l4
            assign or_level4[i] = or_level3[2*i] | or_level3[2*i+1];
        end
    endgenerate

    // Level 5: 8 bits
    generate
        for (i = 0; i < 8; i = i + 1) begin : or_l5
            assign or_level5[i] = or_level4[2*i] | or_level4[2*i+1];
        end
    endgenerate

    // Level 6: 4 bits
    generate
        for (i = 0; i < 4; i = i + 1) begin : or_l6
            assign or_level6[i] = or_level5[2*i] | or_level5[2*i+1];
        end
    endgenerate

    // Level 7: 2 bits
    generate
        for (i = 0; i < 2; i = i + 1) begin : or_l7
            assign or_level7[i] = or_level6[2*i] | or_level6[2*i+1];
        end
    endgenerate

    // Level 8: final OR
    assign or_level8 = or_level7[0] | or_level7[1];

    assign out = or_level8;

endmodule