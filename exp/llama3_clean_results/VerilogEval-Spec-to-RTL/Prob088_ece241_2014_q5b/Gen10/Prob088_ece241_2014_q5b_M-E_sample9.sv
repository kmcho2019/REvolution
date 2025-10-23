module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State A (0) or State B (1)
reg prev_x; // Previous value of input x

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        prev_x <= 1'b0; // Initialize previous x
    end else begin
        prev_x <= x; // Update previous x
        if(state == 1'b0) begin
            if(x == 1'b1) begin
                state <= 1'b1; // Transition from A to B
            end
        end
    end
end

always @(*) begin
    if(state == 1'b0) begin
        z = x; // Output z in state A
    end else begin
        z = ~x; // Output z in state B
    end
end

endmodule