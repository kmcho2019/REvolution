module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

reg [3:0] decoded_sel;

always @(sel) begin
    case (sel)
        3'b000: decoded_sel = 4'b0001;
        3'b001: decoded_sel = 4'b0010;
        3'b010: decoded_sel = 4'b0100;
        3'b011: decoded_sel = 4'b1000;
        3'b100: decoded_sel = 4'b0001; // Misaligned but could be optimized
        3'b101: decoded_sel = 4'b0010; // Misaligned but could be optimized
        default: decoded_sel = 4'b0000;
    endcase
end

always @(data0 or data1 or data2 or data3 or data4 or data5 or decoded_sel) begin
    out = (decoded_sel[0] == 1'b1) ? data0 :
          (decoded_sel[1] == 1'b1) ? data1 :
          (decoded_sel[2] == 1'b1) ? data2 :
          (decoded_sel[3] == 1'b1) ? data3 : 4'b0000;
end

endmodule