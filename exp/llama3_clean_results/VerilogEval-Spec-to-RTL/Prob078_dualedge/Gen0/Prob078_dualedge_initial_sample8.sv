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

// Use a multiplexer to select the output based on the clock edge
always @(clk or q_pos or q_neg) begin
    if (clk == 1'b1) begin
        q <= q_pos;
    end else begin
        q <= q_neg;
    end
end

endmodule