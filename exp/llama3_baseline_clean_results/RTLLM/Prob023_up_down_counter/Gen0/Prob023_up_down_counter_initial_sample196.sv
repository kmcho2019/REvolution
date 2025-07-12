module up_down_counter(
    input         clk,        // Clock signal
    input         reset,      // Reset signal
    input         up_down,    // Control signal to determine counting direction
    output reg [15:0] count   // 16-bit output representing the current counter value
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero
        count <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment the counter if up_down is high
            count <= count + 16'd1;
        end else begin
            // Decrement the counter if up_down is low
            count <= count - 16'd1;
        end
    end
end

endmodule