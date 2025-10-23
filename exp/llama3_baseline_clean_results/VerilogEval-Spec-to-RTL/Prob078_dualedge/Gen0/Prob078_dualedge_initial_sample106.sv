module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;

// Positive edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Output logic to combine q_pos and q_neg
always @(*) begin
    q = q_pos ? q_pos : q_neg;
end

endmodule