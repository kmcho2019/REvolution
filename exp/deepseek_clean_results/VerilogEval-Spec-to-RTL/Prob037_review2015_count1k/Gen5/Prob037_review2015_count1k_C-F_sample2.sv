module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

parameter MAX_COUNT = 10'd999;

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end else begin
        q <= (q == MAX_COUNT) ? 10'b0 : q + 1'b1;
    end
end

endmodule