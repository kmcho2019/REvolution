module BCD_Digit (
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) q <= 4'b0000;
        else if (enable && q == 4'b1001) q <= 4'b0000;
        else if (enable) q <= q + 4'b0001;
    end

endmodule

module TopModule (
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

    BCD_Digit digit0 (.clk(clk), .reset(reset), .enable(1'b1), .q(q[3:0]));
    BCD_Digit digit1 (.clk(clk), .reset(reset), .enable(ena[1]), .q(q[7:4]));
    BCD_Digit digit2 (.clk(clk), .reset(reset), .enable(ena[2]), .q(q[11:8]));
    BCD_Digit digit3 (.clk(clk), .reset(reset), .enable(ena[3]), .q(q[15:12]));

endmodule