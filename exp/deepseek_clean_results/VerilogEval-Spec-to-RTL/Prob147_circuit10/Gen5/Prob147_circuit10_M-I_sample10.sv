module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic - T flip-flop behavior
always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;  // Toggle when both a and b are high
    end
    // Otherwise maintain state (implicit)
end

// Output logic - unified equation
assign q = (a & (state_reg ^ b)) | (~a & b);
assign state = state_reg;

endmodule