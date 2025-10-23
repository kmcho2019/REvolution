module TopModule(
    input clk,
    input d,
    output reg q
);

// Positive-edge triggered flip-flop
reg q_pos;

// Negative-edge triggered flip-flop
reg q_neg;

// Update flip-flops on both clock edges
always @(posedge clk or negedge clk) begin
    if (clk) begin
        q_pos <= d;
    end else begin
        q_neg <= d;
    end
end

// Select output based on clock edge
assign q = clk? q_pos : q_neg;

endmodule