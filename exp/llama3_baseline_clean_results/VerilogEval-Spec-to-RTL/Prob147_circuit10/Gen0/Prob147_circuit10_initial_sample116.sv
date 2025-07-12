module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;
assign q = (a == 0 && b == 1) || (state_reg == 1 && a == 1 && b == 1);

always @(posedge clk) begin
    if(a == 1 && b == 1) begin
        state_reg <= ~state_reg;
    end else if(a == 1 && b == 0) begin
        state_reg <= state_reg;
    end else if(a == 0 && b == 1) begin
        state_reg <= state_reg;
    end else if(a == 0 && b == 0) begin
        state_reg <= state_reg;
    end
end

endmodule