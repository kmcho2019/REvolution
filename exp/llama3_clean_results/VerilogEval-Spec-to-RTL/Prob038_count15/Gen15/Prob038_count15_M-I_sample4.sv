module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Increment the counter on every positive clock edge unless reset is high
always @(posedge clk) begin
    // Check for reset condition and reset counter to 0, or increment counter
    if (reset) 
        q <= 4'd0; // Explicitly reset counter to 0 using decimal notation for clarity
    else if (q == 4'd15) // Check if counter has reached maximum value
        q <= 4'd0; // Reset counter to 0 after reaching maximum value
    else 
        q <= q + 1; // Increment counter
end

endmodule