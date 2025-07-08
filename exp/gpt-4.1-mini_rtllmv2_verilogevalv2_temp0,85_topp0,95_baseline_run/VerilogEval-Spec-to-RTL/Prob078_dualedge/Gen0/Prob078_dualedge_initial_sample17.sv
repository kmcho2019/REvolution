module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_posedge;
reg q_negedge;

// Flip-flop triggered on rising edge of clk
always @(posedge clk) begin
    q_posedge <= d;
end

// Flip-flop triggered on falling edge of clk (using inverted clk)
always @(posedge ~clk) begin
    q_negedge <= d;
end

// Combine outputs from both edges
always @(*) begin
    q = q_posedge | q_negedge;
end

endmodule