module TopModule (
    input clk,
    input reset_n,
    input enable,
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);

reg [3:0] mux_out;

always @(*) begin
    case (sel)
        3'b000: mux_out = data0;
        3'b001: mux_out = data1;
        3'b010: mux_out = data2;
        3'b011: mux_out = data3;
        3'b100: mux_out = data4;
        3'b101: mux_out = data5;
        default: mux_out = 4'b0000;
    endcase
end

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        out <= 4'b0000;
    end else if (enable) begin
        out <= mux_out;
    end
end

endmodule