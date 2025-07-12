module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Using one-hot encoding for states to potentially improve area efficiency
reg [3:0] state;
reg [3:0] next_state;

always @(*) begin
    case (1'b1)
        state[0]: begin // State A
            if (r[0] == 1) next_state = 4'b0001;
            else if (r[1] == 1) next_state = 4'b0010;
            else if (r[2] == 1) next_state = 4'b0100;
            else next_state = 4'b1000;
        end
        state[1]: begin // State B
            if (r[0] == 1) next_state = 4'b0001;
            else next_state = 4'b1000;
        end
        state[2]: begin // State C
            if (r[1] == 1) next_state = 4'b0010;
            else next_state = 4'b1000;
        end
        state[3]: begin // State D (for r2=1)
            if (r[2] == 1) next_state = 4'b0100;
            else next_state = 4'b1000;
        end
        default: next_state = 4'b1000;
    endcase
end

always @(posedge clk) begin
    if (~resetn) state <= 4'b1000;
    else state <= next_state;
end

// Output logic remains straightforward
assign g[0] = state[1]; // State B
assign g[1] = state[2]; // State C
assign g[2] = state[3]; // State D

endmodule