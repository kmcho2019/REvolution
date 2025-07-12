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
    end else begin
        if (up_down) begin
            // Increment count, wrapping around if necessary
            if (count == 16'd65535) begin
                next_count = 16'd0;
            end else begin
                next_count = count + 1;
            end
        end else begin
            // Decrement count, wrapping around if necessary
            if (count == 16'd0) begin
                next_count = 16'd65535;
            end else begin
                next_count = count - 1;
            end
        end
    end
end

always @ (posedge clk) begin
    count <= next_count;
end

endmodule