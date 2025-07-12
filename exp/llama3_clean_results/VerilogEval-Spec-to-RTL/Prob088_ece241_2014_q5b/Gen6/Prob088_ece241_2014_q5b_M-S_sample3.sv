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
    end else begin
        if(x) begin
            state <= 1'b1; // Transition to state B if x is 1
        end
    end
end

always @(*) begin
    if(state) begin // State B
        z = ~x; // z is the inverse of x in state B
    end else begin // State A
        z = x; // z follows x in state A
    end
end

endmodule