module TopModule(
    input  clk,
    input  a,
    output q
);

reg prev_a = 0;
reg q_reg = 1;

always @ (posedge clk) begin
    if (prev_a && a) begin
        q_reg <= 0;
    end else if (!a) begin
        q_reg <= 1;
    end
    prev_a <= a;
end

assign q = q_reg;

endmodule