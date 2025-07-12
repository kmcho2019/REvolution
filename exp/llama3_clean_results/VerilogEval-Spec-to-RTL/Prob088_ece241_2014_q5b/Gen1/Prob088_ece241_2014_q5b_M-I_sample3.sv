module TopModule (
    input clk,
    input areset,
    input x,
    output reg z  // Declare z as a reg
);

reg [1:0] state;  // One-hot encoding for states A and B
reg [1:0] next_state;

always_comb begin
    case (state)
        2'b10: begin  // State A
            if (x) begin
                next_state = 2'b01;  // Transition to B
                z = 1'b1;
            end else begin
                next_state = 2'b10;  // Stay in A
                z = 1'b0;
            end
        end
        2'b01: begin  // State B
            next_state = 2'b01;  // Stay in B
            z = ~x;  // Output inverse of x
        end
        default: begin  // Should not happen in one-hot encoding
            next_state = 2'b10;  // Default to A
            z = 1'b0;
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b10;  // Reset to state A
    end else begin
        state <= next_state;  // Update state
    end
end

endmodule