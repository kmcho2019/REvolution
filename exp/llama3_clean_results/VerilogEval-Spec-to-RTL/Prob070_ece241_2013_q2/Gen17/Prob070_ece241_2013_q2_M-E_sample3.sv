module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define the SOP LUT
reg [1:0] sop_lut;
always @(*) begin
    case ({a, b, c, d})
        4'b0010: sop_lut = 2'b01; // 2
        4'b0111: sop_lut = 2'b01; // 7
        4'b1111: sop_lut = 2'b01; // 15
        default: sop_lut = 2'b00;
    endcase
end

// Define the POS LUT
reg [1:0] pos_lut;
always @(*) begin
    case ({a, b, c, d})
        4'b0000: pos_lut = 2'b00; // 0
        4'b0001: pos_lut = 2'b00; // 1
        4'b0100: pos_lut = 2'b00; // 4
        4'b0101: pos_lut = 2'b00; // 5
        4'b0110: pos_lut = 2'b00; // 6
        4'b1001: pos_lut = 2'b00; // 9
        4'b1010: pos_lut = 2'b00; // 10
        4'b1101: pos_lut = 2'b00; // 13
        4'b1110: pos_lut = 2'b00; // 14
        default: pos_lut = 2'b01;
    endcase
end

// Assign the LUT outputs to the module outputs
assign out_sop = sop_lut[0];
assign out_pos = pos_lut[0];

endmodule