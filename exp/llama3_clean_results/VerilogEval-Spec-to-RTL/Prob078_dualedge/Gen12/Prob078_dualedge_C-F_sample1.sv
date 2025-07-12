module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  
reg q_neg;  

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Select output based on clock edge with consideration for synthesis optimization
assign q = (clk == 1'b1) ? q_pos : q_neg;

endmodule