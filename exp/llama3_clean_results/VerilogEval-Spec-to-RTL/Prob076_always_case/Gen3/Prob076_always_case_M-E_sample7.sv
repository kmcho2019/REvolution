module TopModule(
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);

reg [3:0] data0_en, data1_en, data2_en, data3_en, data4_en, data5_en;

// Decoder
always @(*)
begin
    case(sel)
        3'b000: begin data0_en = 4'b1111; data1_en = 4'b0000; data2_en = 4'b0000; data3_en = 4'b0000; data4_en = 4'b0000; data5_en = 4'b0000; end
        3'b001: begin data0_en = 4'b0000; data1_en = 4'b1111; data2_en = 4'b0000; data3_en = 4'b0000; data4_en = 4'b0000; data5_en = 4'b0000; end
        3'b010: begin data0_en = 4'b0000; data1_en = 4'b0000; data2_en = 4'b1111; data3_en = 4'b0000; data4_en = 4'b0000; data5_en = 4'b0000; end
        3'b011: begin data0_en = 4'b0000; data1_en = 4'b0000; data2_en = 4'b0000; data3_en = 4'b1111; data4_en = 4'b0000; data5_en = 4'b0000; end
        3'b100: begin data0_en = 4'b0000; data1_en = 4'b0000; data2_en = 4'b0000; data3_en = 4'b0000; data4_en = 4'b1111; data5_en = 4'b0000; end
        3'b101: begin data0_en = 4'b0000; data1_en = 4'b0000; data2_en = 4'b0000; data3_en = 4'b0000; data4_en = 4'b0000; data5_en = 4'b1111; end
        default: begin data0_en = 4'b0000; data1_en = 4'b0000; data2_en = 4'b0000; data3_en = 4'b0000; data4_en = 4'b0000; data5_en = 4'b0000; end
    endcase
end

// Gating and ORing
always @(*)
begin
    out = (data0 & data0_en) | (data1 & data1_en) | (data2 & data2_en) | (data3 & data3_en) | (data4 & data4_en) | (data5 & data5_en);
end

endmodule