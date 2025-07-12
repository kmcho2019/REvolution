module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if ((a & b) | (~a & b)) begin
        state_reg <= ~state_reg;
    end
end

assign q = b ? (a ? state_reg : ~state_reg) : state_reg;
assign state = state_reg;

endmodule