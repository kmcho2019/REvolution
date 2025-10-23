module TopModule (
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    // Check if reset is active high
    if (reset) begin
        // Reset the counter to 0
        q <= 4'd0;
    end else begin
        // Increment the counter by 1
        q <= q + 1'd1;
    end
end

endmodule