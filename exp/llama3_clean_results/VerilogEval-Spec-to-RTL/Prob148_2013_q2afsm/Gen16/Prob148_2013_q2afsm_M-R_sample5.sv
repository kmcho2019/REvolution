module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;

// One-hot encoding for states
always @(posedge clk) begin
    if (~resetn) state <= 3'b001;
    else begin
        case (state)
            3'b001: next_state = (r[0])? 3'b010 : (r[1])? 3'b100 : (r[2])? 3'b001 : 3'b001;
            3'b010: next_state = (r[0])? 3'b010 : 3'b001;
            3'b100: next_state = (r[1])? 3'b100 : 3'b001;
            default: next_state = 3'b001;
        endcase
        state <= next_state;
    end
end

// Continuous assignment for g
assign g[0] = state[1];
assign g[1] = state[2];
assign g[2] = state[0];

endmodule