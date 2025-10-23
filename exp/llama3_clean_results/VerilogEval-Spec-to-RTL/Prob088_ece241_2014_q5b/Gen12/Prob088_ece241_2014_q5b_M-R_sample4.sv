module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state_A; // State A
reg state_B; // State B

// State transition logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state_A <= 1'b1; // Reset to state A
        state_B <= 1'b0; // Reset to state B
    end else begin
        if(state_A) begin
            if(x) begin
                state_A <= 1'b0; // Transition from A to B
                state_B <= 1'b1;
            end else begin
                state_A <= 1'b1; // Stay in state A
                state_B <= 1'b0;
            end
        end else if(state_B) begin
            if(x) begin
                state_A <= 1'b0; // Stay in state B
                state_B <= 1'b1;
            end else begin
                state_A <= 1'b0; // Stay in state B
                state_B <= 1'b1;
            end
        end
    end
end

// Output z logic
assign z = (state_A && ~x) || (state_B && x);

endmodule