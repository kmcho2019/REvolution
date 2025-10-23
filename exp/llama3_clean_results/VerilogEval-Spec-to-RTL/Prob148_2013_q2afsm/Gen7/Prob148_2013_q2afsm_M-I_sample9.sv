module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot encoding for states
reg [7:0] state;
reg [7:0] next_state;

// Priority-based next state logic
always @(*) begin
    case (1'b1)
        state[0]: begin // State A
            if (r[0]) next_state = 8'b00000010;
            else if (r[1]) next_state = 8'b00000100;
            else if (r[2]) next_state = 8'b00001000;
            else next_state = 8'b00000001;
        end
        state[1]: begin // State B
            next_state = r[0] ? 8'b00000010 : 8'b00000001;
        end
        state[2]: begin // State C
            next_state = r[1] ? 8'b00000100 : 8'b00000001;
        end
        state[3]: begin // State D
            next_state = r[2] ? 8'b00001000 : 8'b00000001;
        end
        default: next_state = 8'b00000001;
    endcase
end

// State flip-flop with synchronous reset
always @(posedge clk) begin
    if (~resetn) state <= 8'b00000001;
    else state <= next_state;
end

// Output logic
assign g[0] = state[1];
assign g[1] = state[2];
assign g[2] = state[3];

endmodule