module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State transition logic
always @(posedge clk) begin
    case ({a,b})
        2'b00: state_reg <= 0;    // Reset when both low
        2'b11: state_reg <= 1;    // Set when both high
        default: state_reg <= state_reg; // Maintain otherwise
    endcase
end

// Corrected output logic
assign q = a ? ~(state_reg & b) : b;
assign state = state_reg;

endmodule