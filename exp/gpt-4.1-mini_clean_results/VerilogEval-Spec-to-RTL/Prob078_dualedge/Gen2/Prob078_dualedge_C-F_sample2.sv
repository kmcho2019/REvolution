module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg q_pos, q_neg;
reg q_sync; // registered mux output to reduce glitches

// Flip-flop triggered on positive edge of clk
always @(posedge clk) begin
    q_pos <= d;
end

// Flip-flop triggered on positive edge of inverted clk (i.e. negative edge of clk)
always @(posedge ~clk) begin
    q_neg <= d;
end

wire mux_out = clk ? q_pos : q_neg;

// Register the mux output on posedge clk to reduce glitches and improve timing
always @(posedge clk) begin
    q_sync <= mux_out;
end

// Output assignment
always @(*) begin
    // Drive q from registered version to reduce glitches
    q = q_sync;
end

endmodule