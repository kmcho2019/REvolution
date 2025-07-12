module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// Next state logic
always @(posedge clk) begin
    case ({a,b})
        2'b11: state_reg <= ~state_reg;  // Toggle when both are 1
        2'b00: state_reg <= 1'b0;       // Reset when both are 0
        default: state_reg <= state_reg; // Otherwise hold
    endcase
end

// Output logic
assign q = (state_reg & a) | (~state_reg & b);
assign state = state_reg;

endmodule