module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg enable; // Clock enable signal for power optimization
assign enable = 1; // Directly assign enable to 1 for simplicity

always @(posedge clk) begin
    q <= (reset) ? 4'd0 : (enable) ? q + 1 : q; // Utilize conditional operator for concise logic
end

endmodule