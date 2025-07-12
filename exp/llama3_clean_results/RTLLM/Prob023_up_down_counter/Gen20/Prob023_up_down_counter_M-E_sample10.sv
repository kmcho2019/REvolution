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
    if (reset) begin
        next_count = 16'd0;
    end else if (up_down) begin
        next_count = current_count + 1;
        if (next_count == 16'd65536) begin
            next_count = 16'd0;
        end
    end else begin
        next_count = current_count - 1;
        if (next_count == 16'd65536) begin
            next_count = 16'd65535;
        end
    end
end

assign count = current_count;

endmodule