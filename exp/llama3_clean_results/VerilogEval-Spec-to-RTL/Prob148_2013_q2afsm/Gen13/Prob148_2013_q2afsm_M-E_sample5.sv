module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;

// Next state logic
always @(*) begin
    case (state)
        3'b001: // State A
            if (r[0]) next_state = 3'b010; // Go to state B if r0 is 1
            else if (r[1]) next_state = 3'b100; // Go to state C if r1 is 1
            else if (r[2]) next_state = 3'b000; // Go to state D if r2 is 1
            else next_state = 3'b001; // Stay in state A
        3'b010: // State B
            if (r[0]) next_state = 3'b010; // Stay in state B if r0 is 1
            else next_state = 3'b001; // Go to state A if r0 is 0
        3'b100: // State C
            if (r[1]) next_state = 3'b100; // Stay in state C if r1 is 1
            else next_state = 3'b001; // Go to state A if r1 is 0
        default: // State D
            if (r[2]) next_state = 3'b000; // Stay in state D if r2 is 1
            else next_state = 3'b001; // Go to state A if r2 is 0
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= 3'b001;
    else state <= next_state;
end

// Output assignments
assign g[0] = (state == 3'b010);
assign g[1] = (state == 3'b100);
assign g[2] = (state == 3'b000);

endmodule