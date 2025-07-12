module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Thermometer decoder: converts binary sel to one-hot
    wire [255:0] sel_one_hot;
    assign sel_one_hot = (256'b1 << sel);

    // Crossbar implementation using bitwise AND then OR reduction
    wire [255:0] selected_bits;
    assign selected_bits = in & sel_one_hot;

    // OR reduction using parallel tree structure
    // This is equivalent to a 256-input OR gate but with balanced tree structure
    wire [127:0] or_level1;
    wire [63:0]  or_level2;
    wire [31:0]  or_level3;
    wire [15:0]  or_level4;
    wire [7:0]   or_level5;
    wire [3:0]   or_level6;
    wire [1:0]   or_level7;

    genvar i;
    generate
        // Level 1: 128 x 2-input ORs
        for (i = 0; i < 128; i = i + 1) begin
            assign or_level1[i] = selected_bits[2*i] | selected_bits[2*i+1];
        end

        // Level 2: 64 x 2-input ORs
        for (i = 0; i < 64; i = i + 1) begin
            assign or_level2[i] = or_level1[2*i] | or_level1[2*i+1];
        end

        // Level 3: 32 x 2-input ORs
        for (i = 0; i < 32; i = i + 1) begin
            assign or_level3[i] = or_level2[2*i] | or_level2[2*i+1];
        end

        // Level 4: 16 x 2-input ORs
        for (i = 0; i < 16; i = i + 1) begin
            assign or_level4[i] = or_level3[2*i] | or_level3[2*i+1];
        end

        // Level 5: 8 x 2-input ORs
        for (i = 0; i < 8; i = i + 1) begin
            assign or_level5[i] = or_level4[2*i] | or_level4[2*i+1];
        end

        // Level 6: 4 x 2-input ORs
        for (i = 0; i < 4; i = i + 1) begin
            assign or_level6[i] = or_level5[2*i] | or_level5[2*i+1];
        end

        // Level 7: 2 x 2-input ORs
        for (i = 0; i < 2; i = i + 1) begin
            assign or_level7[i] = or_level6[2*i] | or_level6[2*i+1];
        end

        // Final OR
        assign out = or_level7[0] | or_level7[1];
    endgenerate

endmodule