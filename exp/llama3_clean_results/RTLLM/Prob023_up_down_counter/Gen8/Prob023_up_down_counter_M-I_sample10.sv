module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (up_down) begin
            // For increment, simply add 1. If the result overflows (which it will when reaching 65535),
            // the overflow will be automatically handled by the 16-bit width of 'count'.
            count <= count + 1;
        end else begin
            // For decrement, subtract 1. If the result underflows (which it will when 'count' is 0),
            // the underflow will wrap around due to the two's complement representation.
            count <= count - 1;
        end
    end
end

endmodule