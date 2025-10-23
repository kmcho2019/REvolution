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
    if (a & b) begin
        // Toggle state when both inputs are high
        state_reg <= ~state_reg;
    end else if (~a & ~b) begin
        // Reset state when both inputs are low
        state_reg <= 1'b0;
    end
    // Otherwise maintain current state
end

// Output logic
assign q = (state_reg ? a : b);
assign state = state_reg;

endmodule