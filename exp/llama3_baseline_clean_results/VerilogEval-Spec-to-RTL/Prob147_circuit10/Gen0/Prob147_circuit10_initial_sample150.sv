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
    if (a) begin
        if (state_reg == 1'b1) begin
            state_reg <= 1'b1;
        end else begin
            state_reg <= 1'b0;
        end
    end else begin
        state_reg <= state_reg;
    end
end

assign q = (b == 1'b1) ? ~state_reg : 1'b0;

endmodule