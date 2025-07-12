// TopModule with 8 D flip-flops and active high synchronous reset
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'h34; // Initialize q_reg with reset value

always_ff @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34; // Reset to 0x34
    end else begin
        q_reg <= d; // Assign d to q_reg on negative edge of clk
    end
end

assign q = q_reg; // Continuous assignment of q_reg to output q

endmodule