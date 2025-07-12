module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

reg [3:0] out_reg;

always @(*) begin
    case (sel)
        3'b000: out_reg = data0;
        3'b001: out_reg = data1;
        3'b010: out_reg = data2;
        3'b011: out_reg = data3;
        3'b100: out_reg = data4;
        3'b101: out_reg = data5;
        default: out_reg = 4'b0000;
    endcase
end

assign out = out_reg;

endmodule