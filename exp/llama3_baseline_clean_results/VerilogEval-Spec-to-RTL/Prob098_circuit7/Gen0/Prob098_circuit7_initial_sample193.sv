module TopModule (
    input  clk,
    input  a,
    output q
);

reg q_reg;
assign q = q_reg;

initial q_reg = 1'b0;

always @(posedge clk) begin
    if (a == 1'b1) begin
        q_reg <= 1'b0;
    end else if (a == 1'b0) begin
        if (q_reg == 1'b0) begin
            q_reg <= 1'b1;
        end
    end
end

endmodule