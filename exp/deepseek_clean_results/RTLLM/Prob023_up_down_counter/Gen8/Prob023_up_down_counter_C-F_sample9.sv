module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Next count calculation with shared arithmetic
wire [15:0] next_count;
wire [15:0] delta = up_down ? 16'h0001 : 16'hFFFF;  // +1 or -1 (two's complement)

assign next_count = reset ? 16'b0 : (count + delta);

// Simplified enable logic
wire count_enable = ~reset & (up_down | (|count));  // Only count down if not zero

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (count_enable) begin
        count <= next_count;
    end
end

endmodule