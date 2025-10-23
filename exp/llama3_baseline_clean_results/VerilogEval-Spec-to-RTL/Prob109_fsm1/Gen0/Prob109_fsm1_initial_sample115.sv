module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state;  // 1-bit variable to store the current state
reg next_state;  // 1-bit variable to store the next state

// State encoding: 0 - A, 1 - B

always @(*) begin
    case(state)
        0: begin  // State A
            if(in) begin
                next_state = 0;  // Stay in A
            end else begin
                next_state = 1;  // Go to B
            end
        end
        1: begin  // State B
            if(in) begin
                next_state = 1;  // Stay in B
            end else begin
                next_state = 0;  // Go to A
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1;  // Reset to state B
    end else begin
        state <= next_state;  // Update state on every rising edge of the clock
    end
end

// Output logic
assign out = state;  // Out is 0 when in state A, 1 when in state B

endmodule