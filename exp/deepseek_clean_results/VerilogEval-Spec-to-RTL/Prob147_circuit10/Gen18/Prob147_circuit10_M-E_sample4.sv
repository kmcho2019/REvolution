module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State transition logic
wire set_cond = a & b;      // Set condition
wire reset_cond = ~a & ~b;  // Reset condition

always @(posedge clk) begin
    case ({set_cond, reset_cond})
        2'b10: state_reg <= 1'b1;  // Set
        2'b01: state_reg <= 1'b0;  // Reset
        default: state_reg <= state_reg;  // Hold
    endcase
end

// Output logic - optimized XOR/XNOR selection
assign q = state_reg ? ~(a ^ b) : (a ^ b);
assign state = state_reg;

endmodule