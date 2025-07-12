module TopModule(
    input clk,
    input d,
    output reg q
);

// Positive-edge triggered flip-flop
reg pos_ff;
always @(posedge clk) begin
    pos_ff <= d;
end

// Negative-edge triggered flip-flop
reg neg_ff;
always @(negedge clk) begin
    neg_ff <= d;
end

// Use a continuous assignment to select the output based on the clock edge
// This logic is minimalistic and should not introduce significant delays
assign q = (clk) ? pos_ff : neg_ff;

endmodule