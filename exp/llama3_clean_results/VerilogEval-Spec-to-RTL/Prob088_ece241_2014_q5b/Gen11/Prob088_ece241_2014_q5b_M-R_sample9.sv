module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State A (0), State B (1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to State A
        z <= 1'b0; // Reset z to 0
    end else begin
        if (!state) begin // State A
            state <= x; // Transition to B if x=1, stay in A if x=0
            z <= x; // z follows x in State A
        end else begin // State B
            // In State B, state doesn't change based on x
            // But z needs to be the inverse of x
            z <= ~x;
        end
    end
end

endmodule