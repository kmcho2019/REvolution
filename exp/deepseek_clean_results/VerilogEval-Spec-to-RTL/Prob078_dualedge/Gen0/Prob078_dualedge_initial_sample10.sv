module TopModule (
    input clk,
    input d,
    output q
);

reg q_posedge, q_negedge;

// Positive edge triggered flip-flop
always @(posedge clk) begin
    q_posedge <= d;
end

// Negative edge triggered flip-flop
always @(negedge clk) begin
    q_negedge <= d;
end

// Output selection based on clock state
assign q = clk ? q_negedge : q_posedge;

endmodule