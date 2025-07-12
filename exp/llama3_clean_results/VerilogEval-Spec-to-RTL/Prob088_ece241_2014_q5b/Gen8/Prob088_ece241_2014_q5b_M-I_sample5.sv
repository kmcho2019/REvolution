module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding: A (2'b01), B (2'b10)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: // State A
                if(x) begin
                    state <= 2'b10; // Transition to state B if x is 1
                end else begin
                    state <= 2'b01; // Stay in state A if x is 0
                end
            2'b10: // State B
                state <= 2'b10; // Stay in state B regardless of x
            default: state <= 2'b01; // Default to state A
        endcase
    end
end

always @(*) begin
    case(state)
        2'b01: // State A
            z = x; // z follows x in state A
        2'b10: // State B
            z = ~x; // z is the inverse of x in state B
        default: z = 1'b0; // Default output to 0
    endcase
end

endmodule