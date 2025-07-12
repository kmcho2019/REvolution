module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    reg state_reg;

    assign q = (~state_reg & a) | (state_reg & b);
    assign state = state_reg;

    always @(posedge clk) begin
        state_reg <= q;
    end

endmodule