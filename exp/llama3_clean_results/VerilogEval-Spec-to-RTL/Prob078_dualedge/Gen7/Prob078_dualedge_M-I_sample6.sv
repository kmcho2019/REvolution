module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Output of positive-edge triggered flip-flop
reg q_neg;  // Output of negative-edge triggered flip-flop

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Continuous assignment to select output based on clock edge
// Using a ternary operator for simplicity and readability
assign q = (clk) ? q_pos : q_neg;

endmodule