module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] current_count;
reg [15:0] next_count;
reg clock_enable;

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
        current_count <= 16'd0;
    end else if (clock_enable) begin
        if (up_down) begin
            // Increment the counter
            next_count <= current_count + 1;
        end else begin
            // Decrement the counter
            next_count <= current_count - 1;
        end
        current_count <= next_count;
        count <= next_count;
    end
end

// Clock gating mechanism
always @ (*) begin
    if (up_down || !up_down) begin
        clock_enable <= 1'b1;
    end else begin
        clock_enable <= 1'b0;
    end
end

// Handle wrap-around using arithmetic overflow flags
always @ (posedge clk) begin
    if (next_count > 16'd65535) begin
        count <= 16'd0;
    end else if (next_count < 16'd0) begin
        count <= 16'd65535;
    end
end

endmodule