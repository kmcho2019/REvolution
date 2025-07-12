module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND operation
    wire [49:0] and_level1;
    genvar i;
    generate
        for (i = 0; i < 50; i++) begin
            assign and_level1[i] = in[2*i] & in[2*i+1];
        end
    endgenerate

    wire [24:0] and_level2;
    generate
        for (i = 0; i < 25; i++) begin
            assign and_level2[i] = and_level1[2*i] & and_level1[2*i+1];
        end
    endgenerate

    wire [12:0] and_level3;
    generate
        for (i = 0; i < 13; i++) begin
            assign and_level3[i] = and_level2[2*i] & and_level2[2*i+1];
        end
    endgenerate

    wire [6:0] and_level4;
    generate
        for (i = 0; i < 7; i++) begin
            assign and_level4[i] = and_level3[2*i] & and_level3[2*i+1];
        end
    endgenerate

    wire [3:0] and_level5;
    generate
        for (i = 0; i < 4; i++) begin
            assign and_level5[i] = and_level4[2*i] & and_level4[2*i+1];
        end
    endgenerate

    wire [1:0] and_level6;
    generate
        for (i = 0; i < 2; i++) begin
            assign and_level6[i] = and_level5[2*i] & and_level5[2*i+1];
        end
    endgenerate

    assign out_and = and_level6[0] & and_level6[1];

    // OR operation
    wire [49:0] or_level1;
    generate
        for (i = 0; i < 50; i++) begin
            assign or_level1[i] = in[2*i] | in[2*i+1];
        end
    endgenerate

    wire [24:0] or_level2;
    generate
        for (i = 0; i < 25; i++) begin
            assign or_level2[i] = or_level1[2*i] | or_level1[2*i+1];
        end
    endgenerate

    wire [12:0] or_level3;
    generate
        for (i = 0; i < 13; i++) begin
            assign or_level3[i] = or_level2[2*i] | or_level2[2*i+1];
        end
    endgenerate

    wire [6:0] or_level4;
    generate
        for (i = 0; i < 7; i++) begin
            assign or_level4[i] = or_level3[2*i] | or_level3[2*i+1];
        end
    endgenerate

    wire [3:0] or_level5;
    generate
        for (i = 0; i < 4; i++) begin
            assign or_level5[i] = or_level4[2*i] | or_level4[2*i+1];
        end
    endgenerate

    wire [1:0] or_level6;
    generate
        for (i = 0; i < 2; i++) begin
            assign or_level6[i] = or_level5[2*i] | or_level5[2*i+1];
        end
    endgenerate

    assign out_or = or_level6[0] | or_level6[1];

    // XOR operation
    wire [49:0] xor_level1;
    generate
        for (i = 0; i < 50; i++) begin
            assign xor_level1[i] = in[2*i] ^ in[2*i+1];
        end
    endgenerate

    wire [24:0] xor_level2;
    generate
        for (i = 0; i < 25; i++) begin
            assign xor_level2[i] = xor_level1[2*i] ^ xor_level1[2*i+1];
        end
    endgenerate

    wire [12:0] xor_level3;
    generate
        for (i = 0; i < 13; i++) begin
            assign xor_level3[i] = xor_level2[2*i] ^ xor_level2[2*i+1];
        end
    endgenerate

    wire [6:0] xor_level4;
    generate
        for (i = 0; i < 7; i++) begin
            assign xor_level4[i] = xor_level3[2*i] ^ xor_level3[2*i+1];
        end
    endgenerate

    wire [3:0] xor_level5;
    generate
        for (i = 0; i < 4; i++) begin
            assign xor_level5[i] = xor_level4[2*i] ^ xor_level4[2*i+1];
        end
    endgenerate

    wire [1:0] xor_level6;
    generate
        for (i = 0; i < 2; i++) begin
            assign xor_level6[i] = xor_level5[2*i] ^ xor_level5[2*i+1];
        end
    endgenerate

    assign out_xor = xor_level6[0] ^ xor_level6[1];

endmodule