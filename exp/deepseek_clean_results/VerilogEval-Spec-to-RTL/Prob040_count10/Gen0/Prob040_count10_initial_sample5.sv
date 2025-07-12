module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Synchronous reset to 0
    end
    else begin
        if (q == 4'b1001) begin  // If current count is 9
            q <= 4'b0000;        // Wrap around to 0
        end
        else begin
            q <= q + 1;          // Increment count
        end
    end
end

endmodule