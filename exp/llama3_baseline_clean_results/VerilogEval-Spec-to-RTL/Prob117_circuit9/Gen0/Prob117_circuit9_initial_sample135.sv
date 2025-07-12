module TopModule(
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] q_reg = 4; // Initialize q_reg to 4

always @(posedge clk) begin
    if (a == 1'b1) begin
        q_reg <= 4; // Keep q at 4 if a is high
    end else begin
        q_reg <= q_reg + 1'b1; // Increment q if a is low
    end
end

assign q = q_reg;

endmodule