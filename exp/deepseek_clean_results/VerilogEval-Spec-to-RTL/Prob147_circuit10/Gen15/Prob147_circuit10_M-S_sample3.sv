module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// Sequential element with direct next state logic
always @(posedge clk) begin
    if (a & b)
        state_reg <= 1;
    else if (~a & ~b)
        state_reg <= 0;
end

// Output is state XOR (a XOR b)
assign q = state_reg ^ (a ^ b);
assign state = state_reg;

endmodule