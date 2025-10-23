module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

// Sequential logic to update the counter's state
always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to 0 on the positive edge of the clock
        q <= 10'd0;
    end else if (q == 10'd999) begin
        // Wrap the counter around to 0 when it reaches 999
        q <= 10'd0;
    end else begin
        // Increment the counter by 1
        q <= q + 10'd1;
    end
end

endmodule