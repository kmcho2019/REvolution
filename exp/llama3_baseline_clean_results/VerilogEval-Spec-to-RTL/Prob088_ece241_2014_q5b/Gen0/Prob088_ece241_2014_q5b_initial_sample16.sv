module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// One-hot encoding for states: A = 2'b01, B = 2'b10
reg [1:0] state, next_state;

// Define the initial state (A) when reset is asserted
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @* begin
    case(state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                next_state = 2'b01; // Stay in A if x = 0
                z = 1'b0; // Output 0
            end else begin
                next_state = 2'b10; // Transition to B if x = 1
                z = 1'b1; // Output 1
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in B regardless of x
            z = ~x; // Output inverse of x
        end
        default: begin // Should not happen, but handle for completeness
            next_state = 2'b01; // Default to state A
            z = 1'b0;
        end
    endcase
end

endmodule