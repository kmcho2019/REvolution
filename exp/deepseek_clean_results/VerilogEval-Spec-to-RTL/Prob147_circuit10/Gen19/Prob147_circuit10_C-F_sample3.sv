module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    case ({a, b})
        2'b11: state_reg <= 1'b1;  // Set state when both inputs are high
        2'b00: state_reg <= 1'b0;  // Reset state when both inputs are low
        default: state_reg <= state_reg;  // Hold state otherwise
    endcase
end

assign q = a ^ b ^ state_reg;  // Efficient XOR/XNOR implementation
assign state = state_reg;

endmodule