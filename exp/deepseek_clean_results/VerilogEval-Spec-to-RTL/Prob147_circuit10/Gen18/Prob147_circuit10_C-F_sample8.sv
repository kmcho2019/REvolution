module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    case ({a,b})
        2'b11: state_reg <= 1'b1;  // Set when both inputs high
        2'b00: state_reg <= 1'b0; // Reset when both inputs low
        default: state_reg <= state_reg; // Otherwise hold
    endcase
end

assign q = a ^ b ^ state_reg;  // XOR when state=0, XNOR when state=1
assign state = state_reg;

endmodule