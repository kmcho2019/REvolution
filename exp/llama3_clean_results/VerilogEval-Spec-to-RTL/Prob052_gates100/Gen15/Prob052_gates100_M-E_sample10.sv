module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND Tree
    wire [49:0] and_level1;
    wire [24:0] and_level2;
    wire [12:0] and_level3;
    wire [6:0] and_level4;
    wire [3:0] and_level5;
    wire [1:0] and_level6;
    wire and_level7;

    genvar i;
    generate
        for (i = 0; i < 50; i = i + 1) begin
            assign and_level1[i] = in[2*i] & in[2*i+1];
        end
        for (i = 0; i < 25; i = i + 1) begin
            assign and_level2[i] = and_level1[2*i] & and_level1[2*i+1];
        end
        for (i = 0; i < 12; i = i + 1) begin
            assign and_level3[i] = and_level2[2*i] & and_level2[2*i+1];
        end
        for (i = 0; i < 6; i = i + 1) begin
            assign and_level4[i] = and_level3[2*i] & and_level3[2*i+1];
        end
        for (i = 0; i < 3; i = i + 1) begin
            assign and_level5[i] = and_level4[2*i] & and_level4[2*i+1];
        end
        for (i = 0; i < 1; i = i + 1) begin
            assign and_level6[i] = and_level5[2*i] & and_level5[2*i+1];
        end
        assign and_level7 = and_level6[0] & and_level6[1];
    endgenerate

    assign out_and = and_level7;

    // OR Tree
    wire [49:0] or_level1;
    wire [24:0] or_level2;
    wire [12:0] or_level3;
    wire [6:0] or_level4;
    wire [3:0] or_level5;
    wire [1:0] or_level6;
    wire or_level7;

    generate
        for (i = 0; i < 50; i = i + 1) begin
            assign or_level1[i] = in[2*i] | in[2*i+1];
        end
        for (i = 0; i < 25; i = i + 1) begin
            assign or_level2[i] = or_level1[2*i] | or_level1[2*i+1];
        end
        for (i = 0; i < 12; i = i + 1) begin
            assign or_level3[i] = or_level2[2*i] | or_level2[2*i+1];
        end
        for (i = 0; i < 6; i = i + 1) begin
            assign or_level4[i] = or_level3[2*i] | or_level3[2*i+1];
        end
        for (i = 0; i < 3; i = i + 1) begin
            assign or_level5[i] = or_level4[2*i] | or_level4[2*i+1];
        end
        for (i = 0; i < 1; i = i + 1) begin
            assign or_level6[i] = or_level5[2*i] | or_level5[2*i+1];
        end
        assign or_level7 = or_level6[0] | or_level6[1];
    endgenerate

    assign out_or = or_level7;

    // XOR Tree
    wire [49:0] xor_level1;
    wire [24:0] xor_level2;
    wire [12:0] xor_level3;
    wire [6:0] xor_level4;
    wire [3:0] xor_level5;
    wire [1:0] xor_level6;
    wire xor_level7;

    generate
        for (i = 0; i < 50; i = i + 1) begin
            assign xor_level1[i] = in[2*i] ^ in[2*i+1];
        end
        for (i = 0; i < 25; i = i + 1) begin
            assign xor_level2[i] = xor_level1[2*i] ^ xor_level1[2*i+1];
        end
        for (i = 0; i < 12; i = i + 1) begin
            assign xor_level3[i] = xor_level2[2*i] ^ xor_level2[2*i+1];
        end
        for (i = 0; i < 6; i = i + 1) begin
            assign xor_level4[i] = xor_level3[2*i] ^ xor_level3[2*i+1];
        end
        for (i = 0; i < 3; i = i + 1) begin
            assign xor_level5[i] = xor_level4[2*i] ^ xor_level4[2*i+1];
        end
        for (i = 0; i < 1; i = i + 1) begin
            assign xor_level6[i] = xor_level5[2*i] ^ xor_level5[2*i+1];
        end
        assign xor_level7 = xor_level6[0] ^ xor_level6[1];
    endgenerate

    assign out_xor = xor_level7;

endmodule