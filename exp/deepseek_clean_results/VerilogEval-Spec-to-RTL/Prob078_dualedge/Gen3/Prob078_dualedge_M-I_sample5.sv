module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;
reg last_d;

// Detect input changes
wire input_changed = (d != last_d);

always @(posedge clk) begin
    last_d <= d;
    if (input_changed) q_pos <= d;
end

always @(negedge clk) begin
    if (input_changed) q_neg <= d;
end

// Output selection with implicit mux
always @(*) begin
    q = clk ? q_pos : q_neg;
end

endmodule