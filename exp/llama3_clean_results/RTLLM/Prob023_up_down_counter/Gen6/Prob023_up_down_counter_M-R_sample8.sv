module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;

always @ (*) begin
    if (reset) begin
        next_count = 16'd0;
    end else if (up_down) begin
        // Direct increment, implicit wrap-around due to unsigned arithmetic
        next_count = count + 1;
    end else begin
        // Direct decrement, implicit wrap-around due to unsigned arithmetic
        next_count = count - 1;
    end
end

always @ (posedge clk) begin
    count <= next_count;
end

endmodule