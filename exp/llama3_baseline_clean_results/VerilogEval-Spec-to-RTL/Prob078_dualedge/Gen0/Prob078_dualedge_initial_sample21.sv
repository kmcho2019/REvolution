module TopModule (
    input  clk,
    input  d,
    output q
);

reg q_reg;
reg prev_clk;

always @(posedge clk) begin
    prev_clk <= clk;
    if (prev_clk == 1'b0) begin
        // rising edge
        q_reg <= d;
    end
end

always @(negedge clk) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule