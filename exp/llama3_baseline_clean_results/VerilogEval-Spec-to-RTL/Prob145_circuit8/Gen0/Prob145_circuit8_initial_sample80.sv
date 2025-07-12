module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;

assign p = a & clock;

always @(posedge clock or negedge clock) begin
    if (!clock) begin
        if (q_reg) begin
            q_reg <= 1'b1;
        end else begin
            q_reg <= 1'b0;
        end
    end else begin
        if (a) begin
            q_reg <= 1'b1;
        end else if (q_reg == 1'b0) begin
            q_reg <= 1'b0;
        end
    end
end

assign q = q_reg;

endmodule