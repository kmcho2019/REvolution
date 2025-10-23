module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;

    always @(posedge clk) begin
        anyedge <= in ^ in_dly;  // Compute edge detection based on previous input
        in_dly <= in;           // Update delayed input after anyedge computation
    end
endmodule