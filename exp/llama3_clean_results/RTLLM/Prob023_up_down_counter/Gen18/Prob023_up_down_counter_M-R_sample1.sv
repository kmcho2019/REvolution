module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;  // Variable to hold the next state of the counter

// Combinational logic to determine the next state of the counter
always @(*) begin
    if (reset) begin
        next_count = 16'd0;
    end else begin
        next_count = up_down ? (count + 1) % 65536 : (count - 1 + 65536) % 65536;
    end
end

// Sequential logic to update the counter on the rising edge of the clock
always @ (posedge clk) begin
    count <= next_count;
end

endmodule