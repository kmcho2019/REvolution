module up_down_counter(
    input clk,       // Clock signal
    input reset,      // Reset signal
    input up_down,   // Control signal to determine counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= up_down ? (count + 16'd1) : (count - 16'd1);
    end
end

endmodule