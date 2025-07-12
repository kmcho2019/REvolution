module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;
reg clk_gated;

always @ (*) begin
    if (reset) begin
        next_count = 16'd0;
    end else if (up_down) begin
        next_count = count + 1;
        if (next_count == 16'd0) begin
            next_count = 16'd65535;
        end
    end else begin
        next_count = count - 1;
        if (next_count == 16'd65536) begin
            next_count = 16'd0;
        end
    end
end

always @ (posedge clk) begin
    if (up_down || ~up_down) begin
        count <= next_count;
    end
end

endmodule