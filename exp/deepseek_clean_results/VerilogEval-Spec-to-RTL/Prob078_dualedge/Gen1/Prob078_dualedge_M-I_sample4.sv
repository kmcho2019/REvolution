module TopModule (
    input clk,
    input d,
    output q
);

reg pos_q;  // Positive edge triggered flip-flop
reg neg_q;  // Negative edge triggered flip-flop

always @(posedge clk) begin
    pos_q <= d;
end

always @(negedge clk) begin
    neg_q <= d;
end

// The output changes whenever either flip-flop changes
assign q = pos_q ^ neg_q ^ d;

endmodule