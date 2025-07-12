module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos;
reg q_neg;

// Flip-flop triggered on rising edge of clk
always @(posedge clk) begin
    q_pos <= d;
end

// Flip-flop triggered on falling edge of clk
always @(negedge clk) begin
    q_neg <= d;
end

// Combinational assignment of q depending on clk level
assign q = clk ? q_pos : q_neg;

endmodule