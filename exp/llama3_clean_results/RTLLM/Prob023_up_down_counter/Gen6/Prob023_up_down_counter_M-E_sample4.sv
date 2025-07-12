module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;

always @ (*) begin
    if (up_down) begin
        next_count = count + 1;
    end else if (!up_down && count!= 0) begin
        next_count = count - 1;
    end else begin
        next_count = count;
    end
end

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= next_count;
    end
end

endmodule