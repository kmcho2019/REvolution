module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define state encoding explicitly for clarity
reg state; // 1'b0: State A, 1'b1: State B

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A (1'b0)
        state <= 1'b0;
        z <= 1'b0;
    end else begin
        // Transition logic is kept simple to avoid introducing additional delays
        if(!state && x) begin // Transition from A to B
            state <= 1'b1;
            z <= 1'b1;
        end else if(state) begin // Stay in B
            state <= 1'b1;
            z <= ~x;
        end else begin // Stay in A
            state <= 1'b0;
            z <= 1'b0;
        end
    end
end

endmodule