module TopModule(
    input clk,
    input d,
    output reg q
);

// Declare internal signals
reg q_pos, q_neg;

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Combinational logic for output selection
always @(*) begin
    q = clk? q_pos : q_neg;
end

endmodule