module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

// Sequential logic to update the counter's state
always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0; // reset the counter to 0
    end else begin
        // Update the counter based on the next state
        q <= (q == 10'd999) ? 10'd0 : q + 10'd1;
    end
end

endmodule