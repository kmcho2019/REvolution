module counter_12(
    input rst_n,      // Reset signal (active low)
    input clk,       // Clock signal
    input valid_count, // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out; // declare out as a reg to store the current count value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // reset is active low
        out <= 4'b0000; // reset counter to 0
    end else if (valid_count) begin // valid_count is 1
        if (out == 4'd11) begin // check if counter has reached maximum count value
            out <= 4'b0000; // wrap around to 0
        end else begin
            out <= out + 1; // increment counter
        end
    end // if valid_count is 0, out remains unchanged
end

endmodule