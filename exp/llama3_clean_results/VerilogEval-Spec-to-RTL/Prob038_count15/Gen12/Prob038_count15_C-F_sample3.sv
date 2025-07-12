module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Increment the counter on every positive clock edge unless reset is high
always @(posedge clk) begin
    if (reset) // Check for reset condition
        q <= 4'd0; // Reset counter to 0
    else
        q <= q + 1; // Increment counter, leveraging binary wrap-around
end

endmodule