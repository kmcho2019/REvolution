module TopModule(
    input clk,
    input d,
    output reg q = 0
);

reg next_q = 0; // Initialize next state

always @(*) begin
    // Combinational logic to determine next state
    next_q = d;
end

always @(posedge clk) begin
    // Update current state on positive clock edge
    q <= next_q;
end

endmodule