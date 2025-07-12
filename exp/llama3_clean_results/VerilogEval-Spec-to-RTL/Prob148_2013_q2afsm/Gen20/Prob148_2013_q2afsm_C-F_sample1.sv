module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state; // State can be 0, 1, or 2 (for A, B, C respectively)
reg [1:0] next_state;

// Simplified next state logic
always @(*) begin
    case (state)
        2'b00: next_state = (r[0]) ? 2'b01 : (r[1]) ? 2'b10 : (r[2]) ? 2'b11 : 2'b00;
        2'b01: next_state = (r[0]) ? 2'b01 : 2'b00;
        2'b10: next_state = (r[1]) ? 2'b10 : 2'b00;
        2'b11: next_state = (r[2]) ? 2'b11 : 2'b00;
        default: next_state = 2'b00; // Default to state A
    endcase
end

// Use of non-blocking assignment for state update
always @(posedge clk) begin
    if (~resetn) state <= 2'b00; // Reset to state A
    else state <= next_state;
end

// Continuous assignment for g signals
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule