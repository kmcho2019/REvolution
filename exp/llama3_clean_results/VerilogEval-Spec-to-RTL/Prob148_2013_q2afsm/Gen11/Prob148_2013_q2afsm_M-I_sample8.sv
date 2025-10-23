module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Using one-hot encoding for states to potentially reduce switching activity
reg [3:0] state;

// Reset state
parameter RESET_STATE = 4'b0001;

// Next state logic
always @(posedge clk) begin
    if (~resetn) state <= RESET_STATE;
    else begin
        case (1'b1)
            state[0]: // State A
                if (r[0]) state <= 4'b0010;
                else if (r[1]) state <= 4'b0100;
                else if (r[2]) state <= 4'b1000;
                else state <= RESET_STATE;
            state[1]: // State B
                if (r[0]) state <= 4'b0010;
                else state <= RESET_STATE;
            state[2]: // State C
                if (r[1]) state <= 4'b0100;
                else state <= RESET_STATE;
            state[3]: // State D
                if (r[2]) state <= 4'b1000;
                else state <= RESET_STATE;
            default: state <= RESET_STATE;
        endcase
    end
end

// Output logic
assign g[0] = state[1]; // State B
assign g[1] = state[2]; // State C
assign g[2] = state[3]; // State D

endmodule