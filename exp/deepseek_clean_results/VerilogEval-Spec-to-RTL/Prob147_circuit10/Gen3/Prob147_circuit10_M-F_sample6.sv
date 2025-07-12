module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & b)
        state_reg <= ~state_reg;       // Toggle when both inputs are 1
    else if (a & ~b)
        state_reg <= 0;                // Reset when a=1 and b=0
    else if (~a & b)
        state_reg <= 1;                // Set when a=0 and b=1
    // else retain state
end

assign q = (state_reg & ~b) | (~state_reg & b);
assign state = state_reg;

endmodule