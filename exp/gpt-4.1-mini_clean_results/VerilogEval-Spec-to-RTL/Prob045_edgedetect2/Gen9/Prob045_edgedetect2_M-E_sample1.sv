module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] stage1;  // holds current input at clk edge
    reg [7:0] stage2;  // holds previous cycle's stage1 output
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        stage1 <= in;              // capture current input
        stage2 <= stage1;          // delay by one cycle
        edge_detect <= stage1 ^ stage2; // detect edges delayed by one cycle
        anyedge <= edge_detect;    // output edge detection delayed by another cycle
    end
endmodule