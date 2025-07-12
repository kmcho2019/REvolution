module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] internal_count;  // Internal 16-bit counter register

always @ (posedge clk) begin
    if (reset) begin
        internal_count <= 16'd0;
    end else if (up_down) begin
        internal_count <= internal_count + 1;
    end else begin
        internal_count <= internal_count - 1;
    end
end

assign count = internal_count;

endmodule