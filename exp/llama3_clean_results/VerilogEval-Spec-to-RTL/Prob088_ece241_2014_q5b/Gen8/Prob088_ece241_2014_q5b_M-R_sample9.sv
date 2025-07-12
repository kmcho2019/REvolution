module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define states explicitly for clarity
reg state_A, state_B;

// Output z logic using assign for simplicity and combinational nature
assign z = (state_B && ~x) || (state_A && x);

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        // State transition logic
        if(state_A && x) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else if(state_B && ~x) begin
            // No transition needed, staying in state_B
        end else begin
            // Stay in current state if conditions for transition are not met
            state_A <= state_A;
            state_B <= state_B;
        end
    end
end

endmodule