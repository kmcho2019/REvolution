module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] buffer [0:65535]; // Circular buffer to store counter values
reg [15:0] pointer;         // Pointer to the current counter value in the buffer

integer i;
always @ (*) begin
    // Initialize the buffer with a sequence of values from 0 to 65535
    for (i = 0; i < 65536; i++) begin
        buffer[i] = i;
    end
end

always @ (posedge clk) begin
    if (reset) begin
        // Reset the counter to zero
        pointer <= 16'd0;
    end else if (up_down) begin
        // Increment the counter by moving the pointer forward
        pointer <= (pointer + 1) % 65536;
    end else begin
        // Decrement the counter by moving the pointer backward
        pointer <= (pointer - 1 + 65536) % 65536;
    end
end

assign count = buffer[pointer]; // Assign the current counter value to the output

endmodule