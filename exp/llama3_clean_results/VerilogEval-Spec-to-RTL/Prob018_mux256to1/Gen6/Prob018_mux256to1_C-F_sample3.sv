module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the input vector into 16 groups of 16 bits
    wire [15:0] group [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group[i] = in[(i*16)+15:(i*16)];
        end
    endgenerate

    // Select one of the 16 multiplexers using the most significant 4 bits of the select signal
    wire [3:0] mux_sel = sel[7:4];

    // Create a 16-to-1 multiplexer using a hierarchical structure of 2-to-1 multiplexers
    wire [15:0] mux_out;
    wire [3:0] bit_sel = sel[3:0];

    // Level 1: 2-to-1 multiplexers
    wire [7:0] out_level1 [15:0];
    genvar j;
    generate
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 8; j++) begin
                assign out_level1[i][j] = (bit_sel[0] == 0) ? group[i][j*2] : group[i][j*2 + 1];
            end
        end
    endgenerate

    // Level 2: 2-to-1 multiplexers
    wire [3:0] out_level2 [15:0];
    generate
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 4; j++) begin
                assign out_level2[i][j] = (bit_sel[1] == 0) ? out_level1[i][j*2] : out_level1[i][j*2 + 1];
            end
        end
    endgenerate

    // Level 3: 2-to-1 multiplexers
    wire [1:0] out_level3 [15:0];
    generate
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 2; j++) begin
                assign out_level3[i][j] = (bit_sel[2] == 0) ? out_level2[i][j*2] : out_level2[i][j*2 + 1];
            end
        end
    endgenerate

    // Level 4: 2-to-1 multiplexers
    wire out_level4 [15:0];
    generate
        for (i = 0; i < 16; i++) begin
            assign out_level4[i] = (bit_sel[3] == 0) ? out_level3[i][0] : out_level3[i][1];
        end
    endgenerate

    // Select one bit from the output of the chosen multiplexer
    assign out = out_level4[mux_sel];

endmodule