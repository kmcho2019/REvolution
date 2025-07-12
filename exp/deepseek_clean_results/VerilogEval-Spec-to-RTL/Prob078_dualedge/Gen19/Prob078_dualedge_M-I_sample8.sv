module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;
reg clk_prev;

always @(posedge clk or negedge clk) begin
    if (clk != clk_prev) begin  // Detect any edge
        q_reg <= d;
        clk_prev <= clk;
    end
end

assign q = q_reg;

endmodule