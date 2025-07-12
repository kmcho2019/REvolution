module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;
assign p = clock && a;
assign q = q_reg;

always @(posedge clock or negedge clock) begin
    if (!clock) begin
        if (a) begin
            q_reg <= 1;
        end else if (q_reg) begin
            q_reg <= 0;
        end
    end
end

initial begin
    q_reg = 0;
end

endmodule