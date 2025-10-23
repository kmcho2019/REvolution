module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

// Positive-edge triggered flip-flop with clock gating
always @(posedge clk) begin
    if (d !== q_pos) begin
        q_pos <= d;
    end
end

// Negative-edge triggered flip-flop with clock gating
always @(negedge clk) begin
    if (d !== q_neg) begin
        q_neg <= d;
    end
end

// Select output based on clock edge
assign q = clk? q_pos : q_neg;

endmodule