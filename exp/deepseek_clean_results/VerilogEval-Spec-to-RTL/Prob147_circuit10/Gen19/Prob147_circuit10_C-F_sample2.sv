module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;  // Explicit initialization

always @(posedge clk) begin
    case ({a, b})
        2'b11: state_reg <= 1'b1;  // Set state on 11
        2'b00: state_reg <= 1'b0;  // Clear state on 00
        default: state_reg <= state_reg;  // Hold otherwise
    endcase
end

assign q = a ^ b ^ state_reg;  // Optimized XOR implementation
assign state = state_reg;      // Direct output assignment

endmodule