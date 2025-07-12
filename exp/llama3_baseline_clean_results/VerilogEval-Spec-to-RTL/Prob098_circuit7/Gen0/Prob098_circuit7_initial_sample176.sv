module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (~a) begin
        q_reg <= 1'b1; // Set q to 1 when a is 0
    end else if (a) begin
        q_reg <= ~q_reg; // Toggle q when a is 1
    end
end

endmodule