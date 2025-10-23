module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Sequential logic to update the counter state (q) at the positive edge of the clock
always @(posedge clk) begin
    // If reset is high, reset the counter to 0
    if (reset) begin
        q <= 4'd0;
    end else begin
        // Otherwise, increment the counter by 1
        q <= q + 1'd1;
    end
end

endmodule