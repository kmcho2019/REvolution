module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] buffer [0:65535];  // Circular buffer to store counter values
reg [15:0] ptr_current;      // Pointer to current value in buffer
reg [15:0] ptr_next;         // Pointer to next value in buffer

always @ (posedge clk) begin
    if (reset) begin
        ptr_current <= 16'd0;
        ptr_next <= 16'd0;
        buffer[0] <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment counter
            ptr_next <= (ptr_current + 1) % 65536;
        end else begin
            // Decrement counter
            ptr_next <= (ptr_current - 1 + 65536) % 65536;
        end
        // Update current pointer
        ptr_current <= ptr_next;
        // Update buffer value
        buffer[ptr_current] <= ptr_current;
    end
end

always @ (*) begin
    count = buffer[ptr_current];
end

endmodule