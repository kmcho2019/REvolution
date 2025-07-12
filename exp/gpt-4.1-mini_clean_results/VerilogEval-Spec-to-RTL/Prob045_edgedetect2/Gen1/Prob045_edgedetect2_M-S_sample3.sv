module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;

    always @(posedge clk) begin
        anyedge <= in ^ in_dly;  // detect edges from previous input
        in_dly <= in;            // register current input for next cycle
    end
endmodule