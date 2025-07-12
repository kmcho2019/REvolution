module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Synchronous reset to 0
    end
    else if (slowena) begin
        // Simplified comparison for 9 (1001) - check bit 3 and bit 0
        q <= (q[3] & q[0]) ? 4'b0000 : q + 1'b1;
    end
    // If slowena is low, maintain current count
end

endmodule