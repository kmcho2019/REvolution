module up_down_counter(
    input clk,    // Clock signal
    input reset,  // Reset signal
    input up_down, // Control signal for up or down counting
    output [15:0] count // 16-bit output for the current counter value
);

reg [15:0] counter; // 16-bit register to hold the current counter value

// Synchronous process triggered by the rising edge of the clock signal
always @(posedge clk) begin
    if (reset) begin // Reset condition
        counter <= 16'd0; // Reset the counter to zero
    end else if (up_down) begin // Increment condition
        counter <= counter + 1; // Increment the counter
    end else begin // Decrement condition
        counter <= counter - 1; // Decrement the counter
    end
end

// Continuous assignment to output the current counter value
assign count = counter;

endmodule