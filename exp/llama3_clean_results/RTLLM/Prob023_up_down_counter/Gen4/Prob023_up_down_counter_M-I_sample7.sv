module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// Create a gated clock that is only active when the reset is not asserted
wire gated_clk;
assign gated_clk = clk & ~reset;

always @ (posedge gated_clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= (up_down) ? (count + 1) : (count - 1);
    end
end

endmodule