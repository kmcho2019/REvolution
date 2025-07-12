module TopModule(
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [3:0] out
);

wire [5:0] enable; // Enable signals for each data line

// Decoder to generate enable signals
always @(*) begin
    case (sel)
        3'b000: enable = 6'b000001;
        3'b001: enable = 6'b000010;
        3'b010: enable = 6'b000100;
        3'b011: enable = 6'b001000;
        3'b100: enable = 6'b010000;
        3'b101: enable = 6'b100000;
        default: enable = 6'b000000;
    endcase
end

// AND-OR logic to combine gated data lines
assign out[0] = (enable[0] && data0[0]) || (enable[1] && data1[0]) || (enable[2] && data2[0]) || (enable[3] && data3[0]) || (enable[4] && data4[0]) || (enable[5] && data5[0]);
assign out[1] = (enable[0] && data0[1]) || (enable[1] && data1[1]) || (enable[2] && data2[1]) || (enable[3] && data3[1]) || (enable[4] && data4[1]) || (enable[5] && data5[1]);
assign out[2] = (enable[0] && data0[2]) || (enable[1] && data1[2]) || (enable[2] && data2[2]) || (enable[3] && data3[2]) || (enable[4] && data4[2]) || (enable[5] && data5[2]);
assign out[3] = (enable[0] && data0[3]) || (enable[1] && data1[3]) || (enable[2] && data2[3]) || (enable[3] && data3[3]) || (enable[4] && data4[3]) || (enable[5] && data5[3]);

endmodule