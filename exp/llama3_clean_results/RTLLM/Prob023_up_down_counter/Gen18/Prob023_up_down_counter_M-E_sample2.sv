module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] current_count;  // Current count value

always @ (posedge clk) begin
    if (reset) begin
        current_count <= 16'd0;
    end else begin
        if (up_down) begin
            current_count <= current_count + 1;
        end else begin
            current_count <= current_count - 1;
        end
    end
end

always @ (*) begin
    count <= current_count;
end

endmodule