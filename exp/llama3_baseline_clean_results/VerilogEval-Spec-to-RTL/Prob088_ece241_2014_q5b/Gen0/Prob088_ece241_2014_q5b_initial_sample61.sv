module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] next_state;

// Output logic
assign z = (state[1] && x) || (state[1] && ~x) || (state[0] && x);

// Next state logic
always @(*) begin
    case (state)
        2'b10: next_state = x ? 2'b01 : 2'b10; // State A
        2'b01: next_state = 2'b01; // State B, no change
        default: next_state = 2'b10; // Invalid states transition to A
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b10; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule