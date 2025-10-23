module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// The counter is incremented on every positive clock edge unless reset is high
always @(posedge clk) begin
    // Check for reset condition and reset counter to 0, or increment counter
    if (reset) begin
        // Reset the counter to 0 when reset is active
        q <= 4'd0;
    end else begin
        // Increment the counter by 1 when reset is not active
        q <= q + 1'b1;
    end
end

endmodule