module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
reg clk_d;

// Generate delayed inverted clk (half period delay)
always @(posedge clk) begin
    clk_d <= ~clk; // Delay inverted clk by one clk cycle (approx half cycle delay)
end

// Capture d on rising edge of clk
always @(posedge clk) begin
    q_pos <= d;
end

// Capture d on rising edge of delayed inverted clk (approximates negedge clk)
always @(posedge clk_d) begin
    q_neg <= d;
end

// Output selects q_pos or q_neg based on current clk level
assign q = clk ? q_pos : q_neg;

endmodule