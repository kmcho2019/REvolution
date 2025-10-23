module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [3:0] state;
reg [3:0] next_state;

// One-hot encoding for states: A (0001), B (0010), C (0100), D (1000)
always @(*) begin
    case (1'b1)
        state[0]: next_state = (r[0]) ? 4'b0010 : (r[1]) ? 4'b0100 : (r[2]) ? 4'b1000 : 4'b0001;
        state[1]: next_state = (r[0]) ? 4'b0010 : 4'b0001;
        state[2]: next_state = (r[1]) ? 4'b0100 : 4'b0001;
        state[3]: next_state = (r[2]) ? 4'b1000 : 4'b0001;
    endcase
end

always @(posedge clk) begin
    if (~resetn) state <= 4'b0001; // Reset to state A
    else state <= next_state;
end

// Continuous assignment for g
assign g[0] = state[1]; // State B
assign g[1] = state[2]; // State C
assign g[2] = state[3]; // State D

endmodule