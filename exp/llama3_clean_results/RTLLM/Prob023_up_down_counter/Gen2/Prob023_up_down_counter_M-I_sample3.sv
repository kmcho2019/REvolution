module up_down_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg clk_gated; // Clock gating signal

// Clock gating logic
always @ (posedge clk) begin
    if (reset) begin
        clk_gated <= 1'b0;
    end else if (up_down ||!up_down) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Counter logic with clock gating
always @ (posedge clk_gated or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero when the reset signal is active
        count <= 16'd0;
    end else begin
        // Check the up_down control signal to determine the counting direction
        if (up_down) begin
            // Increment the counter when up_down is high
            count <= count + 1;
        end else begin
            // Decrement the counter when up_down is low
            count <= count - 1;
        end
    end
end

endmodule