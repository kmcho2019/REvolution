module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001; // Initialize count to 1 when reset is high
    end else if (q == 4'b1010) begin
        q <= 4'b0001; // Reset count to 1 when it reaches 10
    end else begin
        q <= q + 1'b1; // Increment count by 1
    end
end

endmodule