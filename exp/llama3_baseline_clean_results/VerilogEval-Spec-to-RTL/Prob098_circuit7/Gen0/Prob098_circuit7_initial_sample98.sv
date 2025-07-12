module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;

always @(posedge clk) begin
    if (~a) begin
        q_reg <= 1'b1;
    end else if (a) begin
        q_reg <= 1'b0;
    end
end

assign q = q_reg;

endmodule