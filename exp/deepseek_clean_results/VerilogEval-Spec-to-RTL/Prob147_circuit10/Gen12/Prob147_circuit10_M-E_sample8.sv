module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (a ^ b) begin
        if (b) begin
            state_reg <= ~state_reg;
        end
    end
end

assign q = (state_reg & ~b) | (~state_reg & a & b);
assign state = state_reg;

endmodule