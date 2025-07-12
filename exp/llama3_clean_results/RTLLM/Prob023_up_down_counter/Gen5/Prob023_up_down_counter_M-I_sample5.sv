module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg clk_enable;  // Clock enable signal for clock gating

always @ (posedge clk) begin
    clk_enable <= ~reset;  // Enable clock when reset is inactive
end

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else if (clk_enable) begin
        count <= (up_down) ? (count + 1) : (count - 1);
    end
end

endmodule