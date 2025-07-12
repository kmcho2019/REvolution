module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg q_pos, q_neg;

// Flip-flop triggered on positive edge of clk
always @(posedge clk) begin
    q_pos <= d;
end

// Flip-flop triggered on positive edge of inverted clk (i.e. negative edge of clk)
always @(posedge ~clk) begin
    q_neg <= d;
end

// Combine outputs: when clk=1, use q_pos; when clk=0, use q_neg
always @(*) begin
    q = clk ? q_pos : q_neg;
end

endmodule