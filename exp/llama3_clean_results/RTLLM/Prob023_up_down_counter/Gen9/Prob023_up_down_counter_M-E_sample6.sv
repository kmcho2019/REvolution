module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [7:0] upper_count;  // Upper 8 bits of the counter
reg [7:0] lower_count;  // Lower 8 bits of the counter

// Derive a slower clock for the upper 8 bits
reg slow_clk;
always @ (posedge clk) begin
    slow_clk <= ~slow_clk;
end

always @ (posedge clk) begin
    if (reset) begin
        lower_count <= 8'd0;
    end else begin
        if (up_down) begin
            lower_count <= lower_count + 1;
        end else begin
            lower_count <= lower_count - 1;
        end
    end
end

always @ (posedge slow_clk) begin
    if (reset) begin
        upper_count <= 8'd0;
    end else begin
        if (up_down) begin
            if (lower_count == 8'd255) begin
                upper_count <= upper_count + 1;
                lower_count <= 8'd0;
            end
        end else begin
            if (lower_count == 8'd0) begin
                upper_count <= upper_count - 1;
                lower_count <= 8'd255;
            end
        end
    end
end

assign count = {upper_count, lower_count};

endmodule