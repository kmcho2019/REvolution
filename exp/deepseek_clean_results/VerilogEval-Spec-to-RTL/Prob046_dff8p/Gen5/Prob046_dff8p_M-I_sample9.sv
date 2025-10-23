module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

// Negative edge triggered flip-flops with optimized synchronous reset
always @(negedge clk) begin
    case (reset)
        1'b1: q_reg <= 8'b00110100;  // Direct binary assignment for reset value
        1'b0: q_reg <= d;
    endcase
end

assign q = q_reg;

endmodule