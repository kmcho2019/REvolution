module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] internal_count;

always @ (posedge clk) begin
    if (reset) begin
        internal_count <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment internal_count
            if (internal_count == 16'd65535) begin
                internal_count <= 16'd65535;  // Saturation at maximum value
            end else begin
                internal_count <= internal_count + 1;
            end
        end else begin
            // Decrement internal_count
            if (internal_count == 16'd0) begin
                internal_count <= 16'd0;  // Saturation at minimum value
            end else begin
                internal_count <= internal_count - 1;
            end
        end
    end
end

assign count = internal_count;

endmodule