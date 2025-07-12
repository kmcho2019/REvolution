module up_down_counter(
    input clk,       // Clock signal
    input reset,     // Reset signal
    input up_down,   // Control signal to determine counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset counter to zero when reset signal is active
        count <= 16'd0;
    end else begin
        // Increment or decrement counter based on up_down control signal
        if (up_down) begin
            // Increment counter
            count <= count + 1;
        end else begin
            // Decrement counter
            count <= count - 1;
        end
    end
end

endmodule