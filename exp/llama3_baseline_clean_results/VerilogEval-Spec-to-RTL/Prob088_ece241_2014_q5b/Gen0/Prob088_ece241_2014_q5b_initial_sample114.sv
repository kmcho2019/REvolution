module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] currentState; // One-hot encoding for states A and B
reg [1:0] nextState;
wire z; // Output z is a combinational function of the state and input x

// Combinational logic for next state
always @(*) begin
    case(currentState)
        2'b01: // State A
            if (~x) nextState = 2'b01; // Stay in A if x is 0
            else nextState = 2'b10; // Go to B if x is 1
        2'b10: // State B
            if (~x) nextState = 2'b10; // Stay in B if x is 0
            else nextState = 2'b10; // Stay in B if x is 1
        default: nextState = 2'b01; // Default to state A
    endcase
end

// Combinational logic for output z
assign z = (~currentState[0] & x) | (currentState[0] & (~x | x)); // Output z is 1 when in state B or when in state A and x is 1

// Sequential logic for state register
always @(posedge clk or posedge areset) begin
    if (areset) // Asynchronous reset to state A
        currentState <= 2'b01;
    else
        currentState <= nextState;
end

endmodule