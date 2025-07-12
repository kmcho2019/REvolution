module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;
reg [15:0] current_count;

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment the counter
            if (count == 16'd65535) begin
                count <= 16'd0;  // Wrap around to 0
            end else begin
                count <= count + 1;
            end
        end else begin
            // Decrement the counter
            if (count == 16'd0) begin
                count <= 16'd65535;  // Wrap around to 65535
            end else begin
                count <= count - 1;
            end
        end
    end
end

endmodule