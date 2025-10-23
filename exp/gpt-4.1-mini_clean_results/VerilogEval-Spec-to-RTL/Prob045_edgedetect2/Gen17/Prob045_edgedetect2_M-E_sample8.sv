module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] stage1;
    reg [7:0] stage2;

    always @(posedge clk) begin
        stage1 <= in;
        stage2 <= stage1;
        anyedge <= stage1 ^ stage2; // edge detection delayed by one cycle after transition
    end
endmodule