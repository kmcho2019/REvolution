module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count; // Next value of the counter

// Combinatorial logic to determine the next state of the counter
assign next_count = (reset) ? 16'd0 :
                     (up_down) ? (count == 16'd65535) ? 16'd0 : count + 1 :
                                  (count == 16'd0) ? 16'd65535 : count - 1;

// Register the next state on the rising edge of the clock
always @ (posedge clk) begin
    count <= next_count;
end

endmodule