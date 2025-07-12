module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] next_state;

// Output z is determined by the current state and input x
always @(*) begin
    case (state)
        2'b01: z = ~x; // State A
        2'b10: z = x;  // State B
        default: z = 1'b0; // Default to 0 for invalid states
    endcase
end

// State transitions
always @(*) begin
    case (state)
        2'b01: begin // State A
            if (~x) next_state = 2'b01; // Stay in A if x is 0
            else next_state = 2'b10;    // Move to B if x is 1
        end
        2'b10: begin // State B
            next_state = 2'b10;         // Stay in B regardless of x
        end
        default: next_state = 2'b01;   // Default next state to A
    endcase
end

// Sequential logic to update the state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule