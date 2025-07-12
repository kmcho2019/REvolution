module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;
assign p = a & clock;
always @(posedge clock or negedge clock) begin
    if (~clock) begin
        if (a)
            q_reg <= 1'b1;
        else
            q_reg <= 1'b0;
    end
end
assign q = q_reg;

endmodule