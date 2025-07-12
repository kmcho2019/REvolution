module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd1;  // Reset to 1 (using decimal notation for clarity)
    end
    else begin
        q <= (q == 4'd10) ? 4'd1 : q + 1'd1;  // Ternary operator for compact logic
    end
end

endmodule