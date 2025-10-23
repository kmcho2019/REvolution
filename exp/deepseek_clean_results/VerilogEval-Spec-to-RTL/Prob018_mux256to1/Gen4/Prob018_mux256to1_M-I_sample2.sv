module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First stage: 16 groups of 16-to-1 muxes (only one will be used)
    wire [15:0] stage1_out;
    
    // Only enable the mux group that matches sel[7:4]
    assign stage1_out[0] = (sel[7:4] == 4'd0) ? in[0 + sel[3:0]] : 1'b0;
    assign stage1_out[1] = (sel[7:4] == 4'd1) ? in[16 + sel[3:0]] : 1'b0;
    assign stage1_out[2] = (sel[7:4] == 4'd2) ? in[32 + sel[3:0]] : 1'b0;
    assign stage1_out[3] = (sel[7:4] == 4'd3) ? in[48 + sel[3:0]] : 1'b0;
    assign stage1_out[4] = (sel[7:4] == 4'd4) ? in[64 + sel[3:0]] : 1'b0;
    assign stage1_out[5] = (sel[7:4] == 4'd5) ? in[80 + sel[3:0]] : 1'b0;
    assign stage1_out[6] = (sel[7:4] == 4'd6) ? in[96 + sel[3:0]] : 1'b0;
    assign stage1_out[7] = (sel[7:4] == 4'd7) ? in[112 + sel[3:0]] : 1'b0;
    assign stage1_out[8] = (sel[7:4] == 4'd8) ? in[128 + sel[3:0]] : 1'b0;
    assign stage1_out[9] = (sel[7:4] == 4'd9) ? in[144 + sel[3:0]] : 1'b0;
    assign stage1_out[10] = (sel[7:4] == 4'd10) ? in[160 + sel[3:0]] : 1'b0;
    assign stage1_out[11] = (sel[7:4] == 4'd11) ? in[176 + sel[3:0]] : 1'b0;
    assign stage1_out[12] = (sel[7:4] == 4'd12) ? in[192 + sel[3:0]] : 1'b0;
    assign stage1_out[13] = (sel[7:4] == 4'd13) ? in[208 + sel[3:0]] : 1'b0;
    assign stage1_out[14] = (sel[7:4] == 4'd14) ? in[224 + sel[3:0]] : 1'b0;
    assign stage1_out[15] = (sel[7:4] == 4'd15) ? in[240 + sel[3:0]] : 1'b0;

    // Second stage: binary tree of 2-to-1 muxes (4 levels)
    wire [7:0] level1;
    wire [3:0] level2;
    wire [1:0] level3;
    
    // Level 1: 8 muxes
    assign level1[0] = sel[3] ? stage1_out[1] : stage1_out[0];
    assign level1[1] = sel[3] ? stage1_out[3] : stage1_out[2];
    assign level1[2] = sel[3] ? stage1_out[5] : stage1_out[4];
    assign level1[3] = sel[3] ? stage1_out[7] : stage1_out[6];
    assign level1[4] = sel[3] ? stage1_out[9] : stage1_out[8];
    assign level1[5] = sel[3] ? stage1_out[11] : stage1_out[10];
    assign level1[6] = sel[3] ? stage1_out[13] : stage1_out[12];
    assign level1[7] = sel[3] ? stage1_out[15] : stage1_out[14];
    
    // Level 2: 4 muxes
    assign level2[0] = sel[2] ? level1[1] : level1[0];
    assign level2[1] = sel[2] ? level1[3] : level1[1];
    assign level2[2] = sel[2] ? level1[5] : level1[4];
    assign level2[3] = sel[2] ? level1[7] : level1[6];
    
    // Level 3: 2 muxes
    assign level3[0] = sel[1] ? level2[1] : level2[0];
    assign level3[1] = sel[1] ? level2[3] : level2[2];
    
    // Final output
    assign out = sel[0] ? level3[1] : level3[0];

endmodule