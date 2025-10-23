module TopModule(
    input clk,  // Clock signal
    input d,    // Input data
    output reg q  // Output data
);

// Internal signals for positive and negative edge flip-flops
reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    // Update q_pos on positive edge of clk
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    // Update q_neg on negative edge of clk
    q_neg <= d;
end

// Select output based on clock edge
assign q = clk ? q_pos : q_neg;

endmodule