module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter MAX_COUNT = 4'd9;  // Decimal 9 for clarity

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end
    else begin
        q <= (q == MAX_COUNT) ? 4'd0 : q + 1'b1;
    end
end

endmodule