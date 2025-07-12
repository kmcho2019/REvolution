module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000; // Reset counter to 0 when reset is high
    end else if (q == 4'b1001) begin
        q <= 4'b0000; // Wrap around to 0 after 9
    end else begin
        q <= q + 1; // Increment counter
    end
end

endmodule