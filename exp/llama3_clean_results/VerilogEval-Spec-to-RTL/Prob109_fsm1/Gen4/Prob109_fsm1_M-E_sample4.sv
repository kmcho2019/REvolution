module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal to keep track of the current state
reg next_state; // 1-bit signal to calculate the next state

// Combinational logic to generate the next state
always @(*) begin
    case (state)
        1'b0: next_state = ~in; // A (0) --0--> B, A (0) --1--> A
        1'b1: next_state = in ? 1'b1 : 1'b0; // B (1) --0--> A, B (1) --1--> B
        default: next_state = 1'b1; // Handle any default or unknown state
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (state)
        1'b0: out = 0; // State A
        1'b1: out = 1; // State B
        default: out = 1'b1; // Handle any default or unknown state
    endcase
end

endmodule