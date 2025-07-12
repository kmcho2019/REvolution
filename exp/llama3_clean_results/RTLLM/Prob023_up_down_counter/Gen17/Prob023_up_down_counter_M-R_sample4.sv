module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;

assign next_count = (reset) ? 16'd0 : (up_down) ? (count + 1) % 65536 : (count - 1 + 65536) % 65536;

always @ (posedge clk) begin
    count <= next_count;
end

endmodule