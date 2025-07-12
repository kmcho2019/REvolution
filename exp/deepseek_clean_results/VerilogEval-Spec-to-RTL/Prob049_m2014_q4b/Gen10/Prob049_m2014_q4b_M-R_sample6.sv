module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;
reg prev_clk;

always @(posedge clk or posedge ar) begin
    prev_clk <= clk;
    if (ar) q_reg <= 1'b0;
    else if (clk && !prev_clk) q_reg <= d;  // Positive edge detection
end

assign q = q_reg;

endmodule