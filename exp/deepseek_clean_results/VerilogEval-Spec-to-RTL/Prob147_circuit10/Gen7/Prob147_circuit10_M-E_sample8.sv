module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic
always @(posedge clk) begin
    if (a) begin
        if (b) begin
            state_reg <= 1'b1;  // Set when both a and b are high
        end else begin
            state_reg <= 1'b0;  // Reset when a is high but b is low
        end
    end
    // Otherwise maintain state
end

// Output logic - XNOR-like behavior
assign q = (state_reg & ~b) | (~state_reg & b);
assign state = state_reg;

endmodule