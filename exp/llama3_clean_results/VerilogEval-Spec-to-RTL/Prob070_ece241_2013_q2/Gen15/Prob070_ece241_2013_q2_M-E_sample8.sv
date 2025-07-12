module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define the LUT for SOP expression
reg [1:0] sop_lut[15:0];
initial begin
    sop_lut[0] = 2'b00; // 0000
    sop_lut[1] = 2'b00; // 0001
    sop_lut[2] = 2'b01; // 0010
    sop_lut[3] = 2'b00; // 0011
    sop_lut[4] = 2'b00; // 0100
    sop_lut[5] = 2'b00; // 0101
    sop_lut[6] = 2'b00; // 0110
    sop_lut[7] = 2'b01; // 0111
    sop_lut[8] = 2'b00; // 1000
    sop_lut[9] = 2'b00; // 1001
    sop_lut[10] = 2'b00; // 1010
    sop_lut[11] = 2'b00; // 1011
    sop_lut[12] = 2'b00; // 1100
    sop_lut[13] = 2'b00; // 1101
    sop_lut[14] = 2'b00; // 1110
    sop_lut[15] = 2'b01; // 1111
end

// Define the LUT for POS expression
reg [1:0] pos_lut[15:0];
initial begin
    pos_lut[0] = 2'b01; // 0000
    pos_lut[1] = 2'b01; // 0001
    pos_lut[2] = 2'b00; // 0010
    pos_lut[3] = 2'b00; // 0011
    pos_lut[4] = 2'b01; // 0100
    pos_lut[5] = 2'b01; // 0101
    pos_lut[6] = 2'b01; // 0110
    pos_lut[7] = 2'b00; // 0111
    pos_lut[8] = 2'b00; // 1000
    pos_lut[9] = 2'b01; // 1001
    pos_lut[10] = 2'b01; // 1010
    pos_lut[11] = 2'b00; // 1011
    pos_lut[12] = 2'b00; // 1100
    pos_lut[13] = 2'b01; // 1101
    pos_lut[14] = 2'b01; // 1110
    pos_lut[15] = 2'b00; // 1111
end

// Implement the SOP expression using the LUT
assign out_sop = sop_lut[{a, b, c, d}][1];

// Implement the POS expression using the LUT
assign out_pos = pos_lut[{a, b, c, d}][1];

endmodule