module TopModule (
    input  clk,
    input  d,
    output reg q
);

reg q_pos;
reg q_neg;
reg toggle_sel;

// Capture d at positive edge
always @(posedge clk) begin
    q_pos <= d;
end

// Capture d at negative edge
always @(negedge clk) begin
    q_neg <= d;
end

// Generate toggle_sel signal that flips on every clk edge
// toggle_sel toggles at every clock edge, so it's a clock divider by 2
always @(posedge clk or negedge clk) begin
    toggle_sel <= ~toggle_sel;
end

// Register output q on posedge clk selecting from q_pos or q_neg based on toggle_sel
always @(posedge clk) begin
    q <= toggle_sel ? q_neg : q_pos;
end

endmodule