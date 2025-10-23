module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Unpack input into 256 4-bit elements for easy indexing
    wire [3:0] in_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : unpack_input
            assign in_array[i] = in[i*4 +: 4];
        end
    endgenerate

    // Stage 1: 16 groups of 16 elements each, selected by sel[3:0]
    // For each group, mux 16 inputs to one output
    wire [3:0] stage1_out [0:15];
    genvar g, idx;
    generate
        for (g = 0; g < 16; g = g + 1) begin : stage1_groups
            // Use a function to perform 16-to-1 mux using continuous assignment and ternary operators
            assign stage1_out[g] = (sel[3:0] == 4'd0)  ? in_array[g*16 + 0]  :
                                   (sel[3:0] == 4'd1)  ? in_array[g*16 + 1]  :
                                   (sel[3:0] == 4'd2)  ? in_array[g*16 + 2]  :
                                   (sel[3:0] == 4'd3)  ? in_array[g*16 + 3]  :
                                   (sel[3:0] == 4'd4)  ? in_array[g*16 + 4]  :
                                   (sel[3:0] == 4'd5)  ? in_array[g*16 + 5]  :
                                   (sel[3:0] == 4'd6)  ? in_array[g*16 + 6]  :
                                   (sel[3:0] == 4'd7)  ? in_array[g*16 + 7]  :
                                   (sel[3:0] == 4'd8)  ? in_array[g*16 + 8]  :
                                   (sel[3:0] == 4'd9)  ? in_array[g*16 + 9]  :
                                   (sel[3:0] == 4'd10) ? in_array[g*16 + 10] :
                                   (sel[3:0] == 4'd11) ? in_array[g*16 + 11] :
                                   (sel[3:0] == 4'd12) ? in_array[g*16 + 12] :
                                   (sel[3:0] == 4'd13) ? in_array[g*16 + 13] :
                                   (sel[3:0] == 4'd14) ? in_array[g*16 + 14] :
                                                          in_array[g*16 + 15];
        end
    endgenerate

    // Stage 2: 16-to-1 mux of the stage1_out array selected by sel[7:4]
    // Use similar ternary operator mux
    assign out = (sel[7:4] == 4'd0)  ? stage1_out[0]  :
                 (sel[7:4] == 4'd1)  ? stage1_out[1]  :
                 (sel[7:4] == 4'd2)  ? stage1_out[2]  :
                 (sel[7:4] == 4'd3)  ? stage1_out[3]  :
                 (sel[7:4] == 4'd4)  ? stage1_out[4]  :
                 (sel[7:4] == 4'd5)  ? stage1_out[5]  :
                 (sel[7:4] == 4'd6)  ? stage1_out[6]  :
                 (sel[7:4] == 4'd7)  ? stage1_out[7]  :
                 (sel[7:4] == 4'd8)  ? stage1_out[8]  :
                 (sel[7:4] == 4'd9)  ? stage1_out[9]  :
                 (sel[7:4] == 4'd10) ? stage1_out[10] :
                 (sel[7:4] == 4'd11) ? stage1_out[11] :
                 (sel[7:4] == 4'd12) ? stage1_out[12] :
                 (sel[7:4] == 4'd13) ? stage1_out[13] :
                 (sel[7:4] == 4'd14) ? stage1_out[14] :
                                        stage1_out[15];

endmodule