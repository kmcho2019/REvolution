module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;

initial q_reg = 4; // Initial value when a goes low

always @(posedge clk) begin
    if (!a) begin
        q_reg <= (q_reg + 1) % 8; // Increment and wrap around
    end
end

assign q = q_reg;

endmodule