module TopModule(
    input  clk,
    input  a,
    output q
);

reg q_reg;
initial q_reg = 1; // Initialize output to 1 when a is first 0

always @(posedge clk) begin
    if (a) begin
        q_reg <= ~q_reg;
    end
end

assign q = q_reg;

endmodule