module TopModule (
    input clk,
    input d,
    output q
);

reg pos_q;  // Positive edge triggered flip-flop
reg neg_q;  // Negative edge triggered flip-flop

// Positive edge triggered flip-flop
always @(posedge clk) begin
    pos_q <= d;
end

// Negative edge triggered flip-flop
always @(negedge clk) begin
    neg_q <= d;
end

// Output multiplexer
assign q = clk ? neg_q : pos_q;

endmodule