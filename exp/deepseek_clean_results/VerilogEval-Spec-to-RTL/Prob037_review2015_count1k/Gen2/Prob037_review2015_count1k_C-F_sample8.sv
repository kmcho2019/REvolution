module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0;
    end
    else begin
        q <= (q + 1'b1) % 10'd1000;  // Natural overflow handles wrap-around
    end
end

endmodule