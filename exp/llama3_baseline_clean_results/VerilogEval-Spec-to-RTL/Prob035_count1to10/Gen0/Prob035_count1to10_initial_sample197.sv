module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd1; // Reset to 1 when reset is high
    end else if (q == 4'd10) begin
        q <= 4'd1; // Reset to 1 when count reaches 10
    end else begin
        q <= q + 1; // Increment counter otherwise
    end
end

endmodule