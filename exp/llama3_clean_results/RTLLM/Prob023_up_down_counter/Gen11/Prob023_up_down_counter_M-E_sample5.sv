module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] current_count;
reg [15:0] next_count;

always @ (posedge clk) begin
    if (reset) begin
        current_count <= 16'd0;
    end else begin
        current_count <= next_count;
    end
end

always @ (*) begin
    reg [15:0] incremented_count;
    reg [15:0] decremented_count;

    incremented_count = current_count + 1;
    decremented_count = current_count - 1;

    if (up_down) begin
        next_count = incremented_count;
    end else begin
        next_count = decremented_count;
    end
end

assign count = current_count;

endmodule