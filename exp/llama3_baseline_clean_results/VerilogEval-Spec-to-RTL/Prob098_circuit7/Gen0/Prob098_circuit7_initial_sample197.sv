module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;
assign q = q_reg;

initial q_reg = 1'b1; // initialize q to 1

always @(posedge clk) begin
    if (~a) begin
        q_reg <= 1'b1;
    end else if (a) begin
        q_reg <= ~q_reg;
    end
end

endmodule