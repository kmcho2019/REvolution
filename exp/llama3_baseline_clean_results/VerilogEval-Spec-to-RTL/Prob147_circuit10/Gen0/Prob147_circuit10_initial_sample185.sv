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
    if (state_reg == 0 && a == 0 && b == 0) begin
        state_reg <= 1;
    end
    else if (state_reg == 1 && a == 1 && b == 1) begin
        state_reg <= 1;
    end
    else if (state_reg == 0 && a == 1 && b == 1) begin
        state_reg <= 0;
    end
    else if (state_reg == 1 && a == 0 && b == 0) begin
        state_reg <= 0;
    end
    else begin
        state_reg <= state_reg;
    end
end

assign q = (state_reg == 0) ? b : a;

endmodule