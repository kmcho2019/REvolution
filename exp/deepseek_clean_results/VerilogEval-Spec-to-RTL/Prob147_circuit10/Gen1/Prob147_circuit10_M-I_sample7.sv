module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    case ({a,b})
        2'b11: state_reg <= 1'b1;    // Set when both inputs are high
        2'b00: state_reg <= 1'b0;    // Clear when both inputs are low
        default: state_reg <= state_reg; // Maintain state otherwise
    endcase
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule