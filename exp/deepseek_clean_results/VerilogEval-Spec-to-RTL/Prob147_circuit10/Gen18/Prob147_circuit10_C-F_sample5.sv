module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// Optimized state transition logic
always @(posedge clk) begin
    case ({a, b})
        2'b11: state_reg <= 1'b1;    // Set when both high
        2'b00: state_reg <= 1'b0;    // Reset when both low
        default: state_reg <= state_reg; // Hold otherwise
    endcase
end

// Optimized output logic - single XOR operation
assign q = state_reg ^ (a ^ b);
assign state = state_reg;

endmodule