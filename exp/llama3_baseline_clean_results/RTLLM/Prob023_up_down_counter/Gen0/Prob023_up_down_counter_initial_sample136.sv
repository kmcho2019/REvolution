module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal for direction
    output [15:0] count  // 16-bit output for the current count
);

reg [15:0] current_count;  // Register to hold the current count

// Synchronous process triggered by the rising edge of the clock
always @(posedge clk) begin
    // If reset is active, reset the counter to zero
    if (reset) begin
        current_count <= 16'd0;
    end else begin
        // Based on the up_down signal, decide whether to increment or decrement
        if (up_down) begin
            current_count <= current_count + 1;  // Increment
        end else begin
            current_count <= current_count - 1;  // Decrement
        end
    end
end

// Continuous assignment to output the current count
assign count = current_count;

endmodule