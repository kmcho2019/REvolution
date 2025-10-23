module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;

initial q_reg = 1'b1; // Initial value, can be adjusted based on the problem's initial condition

always @(posedge clk) begin
    if (a) begin
        q_reg <= ~q_reg; // Toggle q when a is 1
    end else begin
        // If a is 0, no change in q
    end
end

assign q = q_reg;

endmodule