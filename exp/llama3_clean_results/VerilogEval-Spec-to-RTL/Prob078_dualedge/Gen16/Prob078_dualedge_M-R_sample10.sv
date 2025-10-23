module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

// Combined positive and negative edge triggered flip-flop logic
always @(posedge clk or negedge clk) begin
    if (clk) begin
        q_pos <= d;
    end else begin
        q_neg <= d;
    end
end

// Select output based on clock edge using a conditional operator
assign q = (clk == 1'b1) ? q_pos : q_neg;

endmodule