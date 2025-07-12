module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0; // Reset to 0 when reset is high
    end else begin
        if (q == 10'd999) begin
            q <= 10'd0; // This is not strictly necessary due to 10-bit wrap-around
        end else begin
            q <= q + 1; // Increment counter
        end
    end
end

endmodule