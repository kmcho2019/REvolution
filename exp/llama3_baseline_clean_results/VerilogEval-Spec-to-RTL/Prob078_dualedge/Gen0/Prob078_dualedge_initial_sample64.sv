module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_reg;
reg prev_clk;

always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin // Detect edge
        q_reg <= d; // Capture data on both edges
    end
end

assign q = q_reg;

endmodule