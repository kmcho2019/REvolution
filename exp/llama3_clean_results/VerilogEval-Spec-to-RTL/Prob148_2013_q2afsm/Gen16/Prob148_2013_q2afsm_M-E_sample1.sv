module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot state encoding: A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000
reg [3:0] state;
reg [3:0] next_state;

// Priority encoder for next state logic
always @(*)
begin
    next_state = 4'b0000;
    if (r[0]) next_state = 4'b0010; // State B
    else if (r[1]) next_state = 4'b0100; // State C
    else if (r[2]) next_state = 4'b1000; // State D
    else next_state = 4'b0001; // State A
end

// Output logic
assign g[0] = state[1]; // State B
assign g[1] = state[2]; // State C
assign g[2] = state[3]; // State D

// Clock enable signal
reg clk_enable;
always @(*)
begin
    clk_enable = 1'b0;
    if (state != next_state) clk_enable = 1'b1;
end

// State register with clock gating
always @(posedge clk)
begin
    if (~resetn)
        state <= 4'b0001; // Reset to state A
    else if (clk_enable)
        state <= next_state;
end

endmodule