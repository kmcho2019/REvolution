module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // First layer: Select one of the 16 groups based on sel[7:4]
    wire [15:0] group_select;
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group_select[i] = (sel[7:4] == i) ? 1'b1 : 1'b0;
        end
    endgenerate

    // Second layer: Select one of the 16 inputs within the chosen group based on sel[3:0]
    wire [3:0] out_temp [15:0];
    generate
        for (i = 0; i < 16; i++) begin
            assign out_temp[i] = in[(i*64) +: 64][sel[3:0]*4 +: 4];
        end
    endgenerate

    // Final selection based on group_select
    assign out = out_temp[0]  & {4{group_select[0]}} |
                 out_temp[1]  & {4{group_select[1]}} |
                 out_temp[2]  & {4{group_select[2]}} |
                 out_temp[3]  & {4{group_select[3]}} |
                 out_temp[4]  & {4{group_select[4]}} |
                 out_temp[5]  & {4{group_select[5]}} |
                 out_temp[6]  & {4{group_select[6]}} |
                 out_temp[7]  & {4{group_select[7]}} |
                 out_temp[8]  & {4{group_select[8]}} |
                 out_temp[9]  & {4{group_select[9]}} |
                 out_temp[10] & {4{group_select[10]}} |
                 out_temp[11] & {4{group_select[11]}} |
                 out_temp[12] & {4{group_select[12]}} |
                 out_temp[13] & {4{group_select[13]}} |
                 out_temp[14] & {4{group_select[14]}} |
                 out_temp[15] & {4{group_select[15]}};

endmodule