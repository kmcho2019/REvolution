module TopModule(
    input  clk,
    input  a,
    output q
);

reg q_reg;
assign q = q_reg;

reg a_prev;
always @(posedge clk) begin
    a_prev <= a;
end

always @(posedge clk) begin
    if (a == 1 && a_prev == 0) begin
        q_reg <= ~q_reg;
    end
end

initial begin
    q_reg = 1;
    a_prev = 0;
end

endmodule