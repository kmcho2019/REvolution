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
    end else begin
        // Check if the counter needs to wrap around or increment
        q <= (q == 10'd999) ? 10'd0 : q + 10'd1;
    end
end

endmodule