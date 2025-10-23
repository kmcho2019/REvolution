module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoding for states A and B
reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
assign z = current_state[1]; // z is 1 if in state B

// Next state logic
always @(*) begin
    case(current_state)
        2'b01: // State A
            if(x) next_state = 2'b10; // Move to B if x is 1
            else next_state = 2'b01; // Stay in A if x is 0
        2'b10: // State B
            next_state = 2'b10; // Stay in B regardless of x
        default:
            next_state = 2'b01; // Default to state A for any other state (should not occur)
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= 2'b01; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule