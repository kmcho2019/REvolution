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
    end else if (up_down) begin
        // Simplified increment logic
        next_count = count + 1;
    end else begin
        // Simplified decrement logic with wrap-around
        next_count = count - 1;
        if (next_count == -1) begin
            next_count = 65535;
        end
    end
end

// Sequential logic to update the counter on the rising edge of the clock
always @ (posedge clk) begin
    count <= next_count;
end

endmodule