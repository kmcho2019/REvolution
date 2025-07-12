module TopModule (
    input clk,
    input a,
    output q
);

reg q_reg;

initial q_reg = 1'b1;

always @(posedge clk) begin
    if (a) begin
        q_reg <= 1'b0;
    end else begin
        q_reg <= 1'b1;
    end
end

assign q = q_reg;

endmodule