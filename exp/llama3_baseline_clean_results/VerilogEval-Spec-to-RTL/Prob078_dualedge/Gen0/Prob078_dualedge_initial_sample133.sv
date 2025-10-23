module TopModule(
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;

// Flip-flop triggered on the positive edge of the clock
always @(posedge clk) begin
    q_pos <= d;
end

// Flip-flop triggered on the negative edge of the clock
always @(negedge clk) begin
    q_neg <= d;
end

// Output logic to select the appropriate output based on the clock edge
assign q = (clk) ? q_pos : q_neg;

endmodule