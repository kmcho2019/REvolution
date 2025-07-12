module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] increment_count;
reg [15:0] decrement_count;

// Clock gating
wire clk_increment = up_down ? clk : 1'b0;
wire clk_decrement = ~up_down ? clk : 1'b0;

always @ (posedge clk_increment) begin
    if (reset) begin
        increment_count <= 16'd0;
    end else begin
        increment_count <= increment_count + 1;
    end
end

always @ (posedge clk_decrement) begin
    if (reset) begin
        decrement_count <= 16'd0;
    end else begin
        decrement_count <= decrement_count - 1;
    end
end

always @ (*) begin
    if (reset) begin
        count <= 16'd0;
    end else if (up_down) begin
        count <= increment_count;
    end else begin
        count <= decrement_count;
    end
end

endmodule