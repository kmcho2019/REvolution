module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [3:0] state;
reg [3:0] next_state;

// One-Hot encoding for states
always @(*) begin
    case (state)
        4'b0001: next_state = (r[0]) ? 4'b0010 : (r[1]) ? 4'b0100 : (r[2]) ? 4'b1000 : 4'b0001;
        4'b0010: next_state = (r[0]) ? 4'b0010 : 4'b0001;
        4'b0100: next_state = (r[1]) ? 4'b0100 : 4'b0001;
        4'b1000: next_state = (r[2]) ? 4'b1000 : 4'b0001;
        default: next_state = 4'b0001;
    endcase
end

// Pipelined state transition logic
always @(posedge clk) begin
    if (~resetn) state <= 4'b0001;
    else state <= next_state;
end

// Distributed reset architecture for each flip-flop
// (Assuming this can be implemented in a specific synthesis tool or technology)

// Output logic derived directly from the current state
assign g[0] = state[1]; // State B
assign g[1] = state[2]; // State C
assign g[2] = state[3]; // State D

endmodule