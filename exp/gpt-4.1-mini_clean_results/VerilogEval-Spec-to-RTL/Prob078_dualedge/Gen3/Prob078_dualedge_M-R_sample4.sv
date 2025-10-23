module TopModule (
    input clk,
    input d,
    output q
);

reg clk_d;
reg q_clk, q_clk_d;

// Generate delayed clock clk_d by toggling at every posedge clk (simulates half-period shift)
always @(posedge clk) begin
    clk_d <= ~clk_d;
end

// Capture input d on posedge clk
always @(posedge clk) begin
    q_clk <= d;
end

// Capture input d on posedge clk_d (phase shifted clk)
always @(posedge clk_d) begin
    q_clk_d <= d;
end

// Output mux: select data from q_clk or q_clk_d depending on clk level
assign q = clk ? q_clk : q_clk_d;

endmodule