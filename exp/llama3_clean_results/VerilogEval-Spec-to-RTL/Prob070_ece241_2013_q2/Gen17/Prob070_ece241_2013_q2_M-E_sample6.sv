module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

reg [1:0] lut_out_sop[0:15];
reg [1:0] lut_out_pos[0:15];

// Initialize the LUT with the desired output values for SOP
initial begin
    lut_out_sop[0] = 1'b0;  // 0
    lut_out_sop[1] = 1'b0;  // 1
    lut_out_sop[2] = 1'b1;  // 2
    lut_out_sop[3] = 1'bx;  // 3 (don't care)
    lut_out_sop[4] = 1'b0;  // 4
    lut_out_sop[5] = 1'b0;  // 5
    lut_out_sop[6] = 1'b0;  // 6
    lut_out_sop[7] = 1'b1;  // 7
    lut_out_sop[8] = 1'bx;  // 8 (don't care)
    lut_out_sop[9] = 1'b0;  // 9
    lut_out_sop[10] = 1'b0;  // 10
    lut_out_sop[11] = 1'bx;  // 11 (don't care)
    lut_out_sop[12] = 1'bx;  // 12 (don't care)
    lut_out_sop[13] = 1'b0;  // 13
    lut_out_sop[14] = 1'b0;  // 14
    lut_out_sop[15] = 1'b1;  // 15
end

// Initialize the LUT with the desired output values for POS
initial begin
    lut_out_pos[0] = 1'b0;  // 0
    lut_out_pos[1] = 1'b0;  // 1
    lut_out_pos[2] = 1'b1;  // 2
    lut_out_pos[3] = 1'bx;  // 3 (don't care)
    lut_out_pos[4] = 1'b0;  // 4
    lut_out_pos[5] = 1'b0;  // 5
    lut_out_pos[6] = 1'b0;  // 6
    lut_out_pos[7] = 1'b1;  // 7
    lut_out_pos[8] = 1'bx;  // 8 (don't care)
    lut_out_pos[9] = 1'b0;  // 9
    lut_out_pos[10] = 1'b0;  // 10
    lut_out_pos[11] = 1'bx;  // 11 (don't care)
    lut_out_pos[12] = 1'bx;  // 12 (don't care)
    lut_out_pos[13] = 1'b0;  // 13
    lut_out_pos[14] = 1'b0;  // 14
    lut_out_pos[15] = 1'b1;  // 15
end

// Use the LUT to generate the output values
always @(a, b, c, d) begin
    reg [3:0] input_comb;
    input_comb = {a, b, c, d};
    out_sop = lut_out_sop[input_comb];
    out_pos = lut_out_pos[input_comb];
end

endmodule