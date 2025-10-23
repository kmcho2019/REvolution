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

// Use continuous assignment to select the output based on the clock edge
assign q = (clk)? pos_ff : neg_ff;

endmodule