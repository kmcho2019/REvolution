module TopModule (
    input  clk,
    input  d,
    output q
);

reg q_pos;
reg q_neg;

// Positive edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative edge triggered flip-flop using posedge of inverted clock
always @(posedge ~clk) begin
    q_neg <= d;
end

// Output mux to select the sampled value depending on clk level
assign q = clk ? q_pos : q_neg;

endmodule