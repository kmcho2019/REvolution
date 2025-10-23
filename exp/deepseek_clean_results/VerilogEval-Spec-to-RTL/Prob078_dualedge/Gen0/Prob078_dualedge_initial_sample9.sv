module TopModule (
    input clk,
    input d,
    output q
);

reg pos_q;  // Positive edge triggered flip-flop
reg neg_q;  // Negative edge triggered flip-flop
reg clk_prev;  // To detect clock edges

always @(posedge clk) begin
    pos_q <= d;
    clk_prev <= 1'b1;
end

always @(negedge clk) begin
    neg_q <= d;
    clk_prev <= 1'b0;
end

// The output is selected based on the last clock edge
assign q = clk_prev ? pos_q : neg_q;

endmodule