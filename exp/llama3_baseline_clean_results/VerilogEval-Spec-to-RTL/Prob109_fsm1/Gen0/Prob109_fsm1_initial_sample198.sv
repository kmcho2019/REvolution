module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal to represent the current state (B: 1, A: 0)
reg next_state; // next state

always @(*) begin
    case (state)
        1'b1: next_state = in ? 1'b1 : 1'b0; // state B
        1'b0: next_state = in ? 1'b0 : 1'b1; // state A
        default: next_state = 1'b1; // default to state B
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        1'b1: out = 1'b1; // output in state B
        1'b0: out = 1'b0; // output in state A
        default: out = 1'b1; // default output
    endcase
end

endmodule