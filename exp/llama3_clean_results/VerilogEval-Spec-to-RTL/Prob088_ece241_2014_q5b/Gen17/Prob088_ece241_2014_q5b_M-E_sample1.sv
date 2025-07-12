module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
        z <= 1'b0; // Initialize z
    end else begin
        case(state)
            1'b1: begin
                if(x) begin
                    state <= 1'b0; // Transition to B
                    z <= 1'b1; // Set z based on transition
                end else begin
                    state <= 1'b1; // Stay in A
                    z <= 1'b0; // Update z
                end
            end
            1'b0: begin
                if(x) begin
                    state <= 1'b0; // Stay in B
                    z <= 1'b0; // Update z
                end else begin
                    state <= 1'b0; // Stay in B
                    z <= 1'b1; // Update z
                end
            end
        endcase
    end
end

endmodule