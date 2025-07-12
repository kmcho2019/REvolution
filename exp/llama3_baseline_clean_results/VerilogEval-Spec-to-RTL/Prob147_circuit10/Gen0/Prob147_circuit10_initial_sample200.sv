module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if (~a & ~b & state_reg) begin
        state_reg <= 1'b1;
    end else if (a & b) begin
        state_reg <= 1'b1;
    end else if (~a & b & ~state_reg) begin
        state_reg <= 1'b0;
    end else if (~a & b & state_reg) begin
        state_reg <= 1'b0;
    end
end

assign q = (a & ~b) | (~a & b);

endmodule