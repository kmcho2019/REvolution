module up_down_counter(
    input         clk,      // Clock signal
    input         reset,    // Reset signal
    input         up_down, // Control signal to determine counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] increment_counter;
reg [15:0] decrement_counter;
reg        increment_enable;
reg        decrement_enable;

// Mode Control Logic
always @(*) begin
    if (up_down) begin
        increment_enable = 1'b1;
        decrement_enable = 1'b0;
    end else begin
        increment_enable = 1'b0;
        decrement_enable = 1'b1;
    end
end

// Increment Counter
always @ (posedge clk) begin
    if (reset) begin
        increment_counter <= 16'd0;
    end else if (increment_enable) begin
        increment_counter <= increment_counter + 1'd1;
    end
end

// Decrement Counter
always @ (posedge clk) begin
    if (reset) begin
        decrement_counter <= 16'd0;
    end else if (decrement_enable) begin
        decrement_counter <= decrement_counter - 1'd1;
    end
end

// Output Mux
always @(*) begin
    if (up_down) begin
        count = increment_counter;
    end else begin
        count = decrement_counter;
    end
end

endmodule