module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if(a == 0) begin
        state_reg <= 0;
    end else if(a == 1 && b == 1 && state_reg == 1) begin
        state_reg <= 1;
    end else if(a == 1 && b == 0 && state_reg == 1) begin
        state_reg <= 0;
    end
end

assign q = (b == 1 && state_reg == 0) || (a == 1 && b == 0);

endmodule