module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    case ({a, b})
        2'b11: state_reg <= 1'b1;  // Set when both a and b are 1
        2'b00: state_reg <= 1'b0;  // Reset when both a and b are 0
        default: state_reg <= state_reg;  // Otherwise maintain state
    endcase
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule