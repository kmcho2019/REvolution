module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire clk_posedge = clk & ~$past(clk);
reg state_reg = 0;

always @* begin
    if (clk_posedge) begin
        state_reg <= a & b ? ~state_reg : state_reg;
    end
end

assign q = (~state_reg & b) | (state_reg & ~a);
assign state = state_reg;

endmodule