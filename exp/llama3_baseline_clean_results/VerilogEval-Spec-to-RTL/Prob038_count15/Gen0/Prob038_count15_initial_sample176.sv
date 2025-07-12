module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;  // Reset counter to 0 when reset is high
    end else begin
        if (q == 4'd15) begin
            q <= 4'd0;  // Reset counter to 0 after reaching 15
        end else begin
            q <= q + 1;  // Increment counter
        end
    end
end

endmodule