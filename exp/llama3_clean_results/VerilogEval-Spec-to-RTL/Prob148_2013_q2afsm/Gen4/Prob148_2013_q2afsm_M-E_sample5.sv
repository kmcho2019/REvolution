module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [3:0] state, next_state;

// Priority encoder for next state logic
always @(*) begin
    if (r[0]) begin
        next_state = 4'b0001; // State B
    end else if (r[1]) begin
        next_state = 4'b0010; // State C
    end else if (r[2]) begin
        next_state = 4'b0100; // State D
    end else begin
        next_state = 4'b1000; // State A
    end
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 4'b1000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Outputs
assign g[0] = state[0]; // State B grants device 0
assign g[1] = state[1]; // State C grants device 1
assign g[2] = state[2]; // State D grants device 2

endmodule