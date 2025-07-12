module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34; // Reset q_reg to the specified value
    end else begin
        q_reg <= d; // Update q_reg with d on negative edge of clk
    end
end

assign q = q_reg;

endmodule