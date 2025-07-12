// TopModule with a simplified 8-bit D flip-flop implementation
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

parameter RESET_VALUE = 8'h34; // Reset value

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule