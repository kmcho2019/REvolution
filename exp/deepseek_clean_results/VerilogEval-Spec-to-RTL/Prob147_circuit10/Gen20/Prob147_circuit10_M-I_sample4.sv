module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
wire state_update;
wire clk_enable;

// Clock gating logic - only enable clock when state might change
assign clk_enable = (a ^ b) | (a & b);

always @(posedge clk) begin
    if (clk_enable) begin
        case ({a,b})
            2'b11: state_reg <= 1'b1;
            2'b00: state_reg <= 1'b0;
            default: state_reg <= state_reg;
        endcase
    end
end

// Optimized XOR implementation
assign q = (a ^ b) ^ state_reg;
assign state = state_reg;

endmodule