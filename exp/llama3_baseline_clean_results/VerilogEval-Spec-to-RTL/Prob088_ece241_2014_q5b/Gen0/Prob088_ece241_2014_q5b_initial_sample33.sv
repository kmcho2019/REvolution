module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] next_state;

// Output logic
always @(state, x) begin
    case(state)
        2'b01: z = x; // In state A, z = x
        2'b10: z = ~x; // In state B, z = ~x (since it's always the opposite of x in B)
        default: z = 1'b0; // For any other state (which should not occur), default z to 0
    endcase
end

// Next state logic
always @(state, x) begin
    case(state)
        2'b01: next_state = (x)? 2'b10 : 2'b01; // If in A and x=1, go to B, else stay in A
        2'b10: next_state = 2'b10; // If in B, always stay in B
        default: next_state = 2'b01; // For any other state, default to A
    endcase
end

// Sequential logic (on positive edge of clock)
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule