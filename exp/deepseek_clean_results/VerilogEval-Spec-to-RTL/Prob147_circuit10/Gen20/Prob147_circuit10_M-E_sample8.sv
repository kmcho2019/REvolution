module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;
wire toggle_enable = (a & b) | (~a & ~b);

always @(posedge clk) begin
    if (toggle_enable) begin
        state_reg <= ~state_reg;
    end
end

assign q = (a & b) ? 1'b1 :       // Highest priority: 11
           (a & ~b) ? state_reg :  // 10 case
           (~a & b) ? ~state_reg : // 01 case
           1'b0;                   // 00 case (but state gets cleared)

assign state = state_reg;

endmodule