module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state, next_state;

// Output z
always @(*)
begin
    case (state)
        2'b10: // State A
            z = x;
        2'b01: // State B
            z = ~x;
        default: 
            z = 1'b0; // Default to 0 for invalid states
    endcase
end

// Next state logic
always @(*)
begin
    case (state)
        2'b10: // State A
            if (~x)
                next_state = 2'b10; // Stay in A if x = 0
            else
                next_state = 2'b01; // Go to B if x = 1
        2'b01: // State B
            next_state = 2'b01; // Stay in B regardless of x
        default: 
            next_state = 2'b10; // Default next state to A for invalid current states
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset)
begin
    if (areset)
        state <= 2'b10; // Asynchronous reset to state A
    else
        state <= next_state;
end

endmodule