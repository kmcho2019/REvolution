module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // If reset is high, reset the counter to 0
        q <= 4'd0;
    end else begin
        // If the current count is 15, wrap around to 0; otherwise, increment
        q <= (q == 4'd15)? 4'd0 : q + 1'd1;
    end
end

endmodule