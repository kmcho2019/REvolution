module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;

always @(posedge clock) begin
    if (a) begin
        q_reg <= q_reg + 1'b1;
    end
end

assign p = a & clock;
assign q = q_reg;

initial begin
    q_reg = 1'b0;
end

endmodule