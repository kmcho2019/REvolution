module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg gated_clk;
wire clk_enable = (q != 4'b1111) || reset;

always @(*) begin
    gated_clk = clk & clk_enable;
end

always @(posedge gated_clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        q <= q + 1'b1;
    end
end

endmodule