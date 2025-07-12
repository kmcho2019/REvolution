module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // First stage: Coarse selection based on the top 4 bits of sel
    wire [3:0] coarse_sel = sel[7:4];
    wire [255:0][3:0] coarse_out;

    // Generate 256 possible 4-bit values, each selected by a unique 4-bit code
    genvar i;
    generate
        for (i = 0; i < 256; i++) begin
            assign coarse_out[i] = in[(i*4 + 3) : (i*4)];
        end
    endgenerate

    // Second stage: Fine selection based on the bottom 4 bits of sel
    wire [3:0] fine_sel = sel[3:0];

    // Use the fine selector to select one of the 16 coarse outputs
    wire [3:0] fine_out;
    always @(*) begin
        case (fine_sel)
            4'd0: fine_out = coarse_out[coarse_sel*16 + 0];
            4'd1: fine_out = coarse_out[coarse_sel*16 + 1];
            4'd2: fine_out = coarse_out[coarse_sel*16 + 2];
            4'd3: fine_out = coarse_out[coarse_sel*16 + 3];
            4'd4: fine_out = coarse_out[coarse_sel*16 + 4];
            4'd5: fine_out = coarse_out[coarse_sel*16 + 5];
            4'd6: fine_out = coarse_out[coarse_sel*16 + 6];
            4'd7: fine_out = coarse_out[coarse_sel*16 + 7];
            4'd8: fine_out = coarse_out[coarse_sel*16 + 8];
            4'd9: fine_out = coarse_out[coarse_sel*16 + 9];
            4'd10: fine_out = coarse_out[coarse_sel*16 + 10];
            4'd11: fine_out = coarse_out[coarse_sel*16 + 11];
            4'd12: fine_out = coarse_out[coarse_sel*16 + 12];
            4'd13: fine_out = coarse_out[coarse_sel*16 + 13];
            4'd14: fine_out = coarse_out[coarse_sel*16 + 14];
            4'd15: fine_out = coarse_out[coarse_sel*16 + 15];
            default: fine_out = 4'd0;
        endcase
    end

    // Assign the final output
    assign out = fine_out;

endmodule