module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] stage1, stage2;

    always @(posedge clk) begin
        stage1 <= in;
        stage2 <= stage1;
        anyedge <= stage1 ^ stage2;
    end
endmodule