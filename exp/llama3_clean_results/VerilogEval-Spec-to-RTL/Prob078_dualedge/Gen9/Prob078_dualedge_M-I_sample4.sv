module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_q; // Positive-edge triggered flip-flop output
reg neg_q; // Negative-edge triggered flip-flop output

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    pos_q <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    neg_q <= d;
end

// Output selection logic optimized for area
assign q = clk ? pos_q : neg_q;

endmodule