module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0;
    end else if (q < 10'd1000) begin
        q <= q + 1;
    end else begin
        q <= 10'd0;
    end
end

endmodule