module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_ff;  // Output of positive-edge triggered flip-flop
reg q_latch;  // Output of negative-edge triggered latch

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_ff <= d;
end

// Negative-edge triggered latch
always @(*) begin
    if (~clk) begin
        q_latch = d;
    end
end

// Select output based on clock edge
always @(posedge clk or negedge clk) begin
    if (clk) begin
        q <= q_ff;
    end else begin
        q <= q_latch;
    end
end

endmodule