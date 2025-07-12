module TopModule(
    input clk,
    input reset,
    output reg [3:0] q // Counter output
);

// Counter logic: Sequential block to handle reset and counting
always @(posedge clk) begin
    // Synchronous reset logic: Reset counter to 0 when reset is high
    if (reset) begin
        q <= 4'd0; // Reset counter to 0
    end else begin
        // Increment counter by 1 (will wrap around at 15)
        q <= (q == 4'd15) ? 4'd0 : q + 1;
    end
end

endmodule