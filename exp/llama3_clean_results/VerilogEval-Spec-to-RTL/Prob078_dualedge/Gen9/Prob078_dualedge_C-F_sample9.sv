module TopModule(
    input clk,
    input d,
    output reg q
);

// Positive-edge triggered flip-flop
reg q_pos;

// Negative-edge triggered flip-flop
reg q_neg;

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Select output based on clock edge
assign q = clk? q_pos : q_neg;

endmodule