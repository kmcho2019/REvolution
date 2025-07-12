module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Stage 1: Select one of 16 groups of 16 bits
    wire [15:0] group_select [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group_select[i] = in[(i*16)+15:(i*16)];
        end
    endgenerate

    // Stage 2: Select one of 4 bits from the chosen group using a tree-based structure
    wire [3:0] bit_select [15:0];
    generate
        for (i = 0; i < 16; i++) begin
            wire [1:0] out_level1;
            assign out_level1[0] = (sel[0] == 0) ? group_select[i][0] : group_select[i][1];
            assign out_level1[1] = (sel[0] == 0) ? group_select[i][2] : group_select[i][3];

            wire [1:0] out_level2;
            assign out_level2[0] = (sel[1] == 0) ? out_level1[0] : out_level1[1];
            assign out_level2[1] = (sel[1] == 0) ? group_select[i][4] : group_select[i][5];

            assign bit_select[i][0] = out_level2[0];
            assign bit_select[i][1] = out_level2[1];
            assign bit_select[i][2] = (sel[1] == 0) ? group_select[i][6] : group_select[i][7];
            assign bit_select[i][3] = (sel[1] == 0) ? group_select[i][8] : group_select[i][9];
        end
    endgenerate

    // Stage 3: Select the correct bit using a final 2-to-1 multiplexer
    wire [3:0] selected_bits;
    assign selected_bits = bit_select[sel[7:4]];

    assign out = (sel[3:2] == 2'b00) ? selected_bits[0] :
                 (sel[3:2] == 2'b01) ? selected_bits[1] :
                 (sel[3:2] == 2'b10) ? selected_bits[2] :
                 selected_bits[3];

endmodule