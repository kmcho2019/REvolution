module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Output of positive-edge triggered flip-flop
reg q_neg;  // Output of negative-edge triggered flip-flop

// Single always block capturing both edges
always @(posedge clk or negedge clk) begin
    if (clk) begin
        q_pos <= d;
    end else begin
        q_neg <= d;
    end
end

// Directly select the output in a single statement
assign q = (clk) ? q_pos : q_neg;

endmodule