module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) q <= 10'd0;
    else q <= q + 1'b1;
end

endmodule