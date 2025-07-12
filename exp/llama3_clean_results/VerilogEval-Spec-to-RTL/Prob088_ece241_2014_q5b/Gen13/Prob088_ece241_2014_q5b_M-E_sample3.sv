module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // State A (2'b01) and state B (2'b10)

// Look-up table implementation
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: state <= x ? 2'b10 : 2'b01; // Transition from A to B or stay in A
            2'b10: state <= 2'b10; // Stay in B
            default: state <= 2'b01; // Default to state A for any other state
        endcase
    end
end

always @(*) begin
    case(state)
        2'b01: z = x; // Output for state A
        2'b10: z = ~x; // Output for state B
        default: z = 1'b0; // Default output for any other state
    endcase
end

endmodule