module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic - toggles only when both a and b are high
always @(posedge clk) begin
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - q is XOR of state and b
assign q = state_reg ^ b;
assign state = state_reg;

endmodule