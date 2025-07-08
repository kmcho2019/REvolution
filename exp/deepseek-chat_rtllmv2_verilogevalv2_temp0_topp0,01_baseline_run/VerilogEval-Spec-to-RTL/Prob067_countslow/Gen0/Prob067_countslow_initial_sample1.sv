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
        if (q == 4'b1001) begin  // If current count is 9
            q <= 4'b0000;        // Wrap around to 0
        end
        else begin
            q <= q + 1'b1;       // Otherwise increment
        end
    end
    // If slowena is low, maintain current count
end

endmodule