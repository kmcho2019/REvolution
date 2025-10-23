module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State A (0) or State B (1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        z <= 1'b0; // Initialize z to 0 during reset
    end else begin
        if(x && !state) begin
            state <= 1'b1; // Transition to state B if x is 1 and in state A
        end
        z <= (state) ? ~x : x; // z is determined by the current state and x
    end
end

endmodule