module TopModule (
    input clk,
    input reset,
    input enable,    // Added enable signal for power optimization
    output reg [3:0] q
);

parameter RESET_VALUE = 4'b0001;  // Reset to 1
parameter WRAP_VALUE = 4'b1010;   // Wrap at 10 (binary 1010)

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VALUE;        // Synchronous reset
    end
    else if (enable) begin      // Only count when enabled
        if (q[3] & q[1]) begin  // Efficient check for 10 (1010)
            q <= RESET_VALUE;    // Wrap around
        end
        else begin
            q <= q + 4'b0001;   // Normal increment
        end
    end
    // When not enabled, maintain current value (reduces power)
end

endmodule