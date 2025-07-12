module up_down_counter(
    input         clk,      // Clock signal
    input         reset,    // Reset signal
    input         up_down, // Control signal to determine counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] increment_value;
reg [15:0] decrement_value;

always @ (*) begin
    // Calculate the incremented and decremented values
    increment_value = count + 1'd1;
    decrement_value = count - 1'd1;
end

always @ (posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset is active
        count <= 16'd0;
    end else begin
        // Use a multiplexer to select between the incremented and decremented values
        count <= up_down? increment_value : decrement_value;
    end
end

endmodule