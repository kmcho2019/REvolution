module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;
assign q = b;

always @(posedge clk) begin
    if (a == 1'b1) begin
        if (b == 1'b1) begin
            state_reg <= 1'b1;
        end
    end else begin
        if (b == 1'b1) begin
            state_reg <= ~state_reg;
        end
    end
end

endmodule