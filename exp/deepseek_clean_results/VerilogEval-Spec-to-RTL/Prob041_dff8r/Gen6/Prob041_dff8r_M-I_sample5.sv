module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] d_prev;
wire clk_enable = (d != d_prev) || reset;

always @(posedge clk) begin
    d_prev <= d;
    if (reset) begin
        q <= 8'b0;
    end
    else if (clk_enable) begin
        q <= d;
    end
end

endmodule