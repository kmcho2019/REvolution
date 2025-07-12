module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // Single flip-flop to represent the state (A=0, B=1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        z <= 1'b0; // Initialize z to 0
    end else begin
        if(state == 1'b0 && x == 1'b1) begin
            state <= 1'b1; // Transition from A to B
            z <= 1'b1; // Set z to 1
        end else if(state == 1'b1) begin
            z <= ~x; // In state B, z is the inverse of x
        end else begin
            z <= 1'b0; // In state A and x=0, z remains 0
        end
    end
end

endmodule