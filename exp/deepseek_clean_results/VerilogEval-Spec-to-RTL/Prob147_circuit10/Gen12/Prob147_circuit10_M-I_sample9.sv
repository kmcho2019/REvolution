module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State update logic - toggles when a and b differ
always @(posedge clk) begin
    if (a ^ b) begin
        state_reg <= ~state_reg;
    end
end

// Output logic - XOR combination of state and (a & b)
assign q = state_reg ^ (a & b);
assign state = state_reg;

endmodule