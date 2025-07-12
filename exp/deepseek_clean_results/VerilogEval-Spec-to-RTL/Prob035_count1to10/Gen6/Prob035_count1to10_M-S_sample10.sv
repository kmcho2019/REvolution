module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Reset to 1
    end
    else begin
        q <= (q == 4'd10) ? 4'd1 : q + 1;  // Simple comparison with 10
    end
end

endmodule