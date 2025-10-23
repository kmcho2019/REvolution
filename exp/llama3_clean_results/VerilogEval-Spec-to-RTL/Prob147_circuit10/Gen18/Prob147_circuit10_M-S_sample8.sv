module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0; // Explicitly initialize state_reg to 0

always @(posedge clk) begin
    case ({a, b})
        2'b01: state_reg <= 1'b1; // Set state to 1 when a=0, b=1
        2'b11: state_reg <= 1'b0; // Reset state to 0 when a=1, b=1
        default: state_reg <= state_reg; // No change for other combinations
    endcase
end

assign q = (state_reg) || (a && ~b); // q is 1 when state is 1 or a=1, b=0
assign state = state_reg;

endmodule