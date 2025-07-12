module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state_A; // One-hot encoding for state A
reg state_B; // One-hot encoding for state B

// Combinational logic for output z
assign z = (state_A && ~x) || (state_B && x);

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state_A <= 1'b1; // Reset to state A
        state_B <= 1'b0;
    end else begin
        if(state_A && x) begin // Transition from A to B
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else if(state_B) begin // Stay in B
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else begin // Stay in A
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
    end
end

endmodule