module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

assign z = state ^ x; // Directly calculate z using XOR

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A
        state <= 1'b0;
    end else begin
        // State transition logic based on current state and x
        if(!state && x) begin
            state <= 1'b1; // Transition from A to B when x=1
        end else if(state) begin
            // Stay in B regardless of x
            state <= 1'b1;
        end else begin
            // Stay in A when x=0
            state <= 1'b0;
        end
    end
end

endmodule