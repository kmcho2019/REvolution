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
        // Calculate direction (1 for increment, -1 for decrement)
        reg [15:0] direction;
        if (up_down) begin
            direction <= 16'd1;
        end else begin
            direction <= 16'd65536 - 16'd1; // -1 in 16-bit unsigned arithmetic
        end

        // Calculate next counter value using bitwise operations
        count <= (count + direction) % 16'd65536;
    end
end

endmodule