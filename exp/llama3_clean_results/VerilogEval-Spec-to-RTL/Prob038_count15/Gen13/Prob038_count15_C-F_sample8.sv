module TopModule(
    input  clk, // Clock signal
    input  reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Internal counter register
reg [3:0] counter;

// Increment the counter on every positive clock edge unless reset is high
always @(posedge clk) begin
    // Check for reset condition and reset counter to 0, or increment counter
    if (reset) begin
        // Reset counter to 0
        counter <= 4'd0;
    end else begin
        // Increment counter
        counter <= counter + 1'b1;
    end
end

// Assign counter value to output
assign q = counter;

endmodule