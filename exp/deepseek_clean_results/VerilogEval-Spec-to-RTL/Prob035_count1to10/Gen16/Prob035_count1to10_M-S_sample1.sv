module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 1;         // Reset to 1
    end
    else if (q == 10) begin  // Check for 10
        q <= 1;         // Wrap around to 1
    end
    else begin
        q <= q + 1;     // Increment counter
    end
end

endmodule