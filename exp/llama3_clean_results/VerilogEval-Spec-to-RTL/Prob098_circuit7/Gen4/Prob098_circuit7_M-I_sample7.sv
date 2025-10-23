module TopModule(
    input  clk,
    input  a,
    output q
);

reg q_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (a == 0) begin
        q_reg <= 1'b1; // Explicitly assign 1'b1 for clarity and synthesis optimization
    end else if (q_reg == 1'b1) begin
        q_reg <= 1'b0; // Explicitly assign 1'b0 for clarity and synthesis optimization
    end
end

endmodule