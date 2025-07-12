module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // One-hot encoded state
reg [1:0] next_state;

// Output logic
assign z = (state[0] && x) || (state[1] && ~x);

// Next state logic
always @(*) begin
    case(state)
        2'b01: next_state = x ? 2'b10 : 2'b01; // State A
        2'b10: next_state = 2'b10; // State B
        default: next_state = 2'b01; // Invalid state, go to A
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule