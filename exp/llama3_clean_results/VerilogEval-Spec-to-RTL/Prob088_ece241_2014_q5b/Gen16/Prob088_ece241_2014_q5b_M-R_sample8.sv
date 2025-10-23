module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State variable, 1 for A, 0 for B

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
        z <= 1'b0; // Reset output
    end else begin
        if(state == 1'b1) begin
            if(x) begin
                state <= 1'b0; // Transition from A to B
                z <= 1'b1; // Output for transition
            end else begin
                state <= 1'b1; // Stay in A
                z <= 1'b0; // Output for staying in A
            end
        end else begin // state == 1'b0
            state <= 1'b0; // Stay in B
            z <= 1'b0; // Output for staying in B when x=1
            if(x) begin
                z <= 1'b0; // Output when x=1 and in B
            end else begin
                z <= 1'b1; // Output when x=0 and in B
            end
        end
    end
end

endmodule