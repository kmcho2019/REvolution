module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    case ({a,b})
        2'b11: state_reg <= ~state_reg;  // Toggle on both high
        2'b00: if (!state_reg) state_reg <= 1'b1;  // Set to 1 if currently 0
        default: state_reg <= state_reg;  // Maintain otherwise
    endcase
end

assign q = (state_reg ^ b) & (a | b);  // XOR but only when a or b is active
assign state = state_reg;

endmodule