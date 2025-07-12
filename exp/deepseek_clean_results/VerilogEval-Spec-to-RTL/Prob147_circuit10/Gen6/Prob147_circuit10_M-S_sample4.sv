module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & b) begin
        state_reg <= 1;
    end
end

assign q = a;
assign state = state_reg;

endmodule