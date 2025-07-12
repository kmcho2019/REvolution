module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly = 8'b0;

    always @(posedge clk) begin
        anyedge <= in ^ in_dly;
        in_dly <= in;
    end
endmodule