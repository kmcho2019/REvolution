module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

// Dual-edge triggered flip-flop using a single always block
always @(posedge clk or negedge clk) begin
    q_pos <= d;
    q_neg <= d;
end

// Select output based on clock edge
assign q = clk ? q_pos : q_neg;

endmodule