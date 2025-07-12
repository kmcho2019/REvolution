module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // 1-bit signal to represent the state
reg [0:0] next_state; // 1-bit signal to represent the next state

always @(*) begin
    case(state)
        1'b0: begin // State A
            if (~in) next_state = 1'b1; // in=0, go to state B
            else next_state = 1'b0; // in=1, stay in state A
        end
        1'b1: begin // State B
            if (~in) next_state = 1'b1; // in=0, stay in state B
            else next_state = 1'b1; // in=1, stay in state B
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        1'b0: out = 1'b0; // State A, out=0
        1'b1: out = 1'b1; // State B, out=1
    endcase
end

endmodule