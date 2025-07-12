module TopModule (
    input clk,
    input d,
    output q
);

// Storage elements for both clock edges
reg q_pos, q_neg;

// Capture data on positive clock edge
always @(posedge clk) begin
    q_pos <= d;
end

// Capture data on negative clock edge
always @(negedge clk) begin
    q_neg <= d;
end

// Select appropriate output based on current clock phase
assign q = clk ? q_pos : q_neg;

endmodule