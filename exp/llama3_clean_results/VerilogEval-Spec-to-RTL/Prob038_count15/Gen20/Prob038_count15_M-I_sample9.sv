module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Explicitly reset the counter to 0 on the positive edge of the clock when reset is high.
        q <= 4'd0;
    end else begin
        // Increment the counter on each positive edge of the clock if reset is low.
        if (q == 4'd15) begin
            q <= 4'd0;
        end else begin
            q <= q + 1'd1;
        end
    end
end

endmodule