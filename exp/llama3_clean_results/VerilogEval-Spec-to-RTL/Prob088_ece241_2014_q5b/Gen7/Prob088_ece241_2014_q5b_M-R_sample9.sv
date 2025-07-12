module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State A = 0, State B = 1

assign z = (state == 1'b0) ? ~x : x; // Directly assign z based on state and x

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        // Transition to state B if in state A and x=1, otherwise stay in current state
        if(state == 1'b0 && x == 1'b1) begin
            state <= 1'b1;
        end
    end
end

endmodule