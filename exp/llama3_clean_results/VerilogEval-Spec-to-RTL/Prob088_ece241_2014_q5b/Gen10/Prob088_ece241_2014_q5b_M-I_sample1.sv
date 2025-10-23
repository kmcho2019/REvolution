module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define state encoding explicitly for clarity
reg state; // 1'b0: State A, 1'b1: State B

// Use assign for output z logic to simplify
assign z = state ? ~x : x;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A (1'b0)
        state <= 1'b0;
    end else begin
        // Transition logic: Stay in A if x=0, move to B if x=1 from A, stay in B if already in B
        if (!state && x) begin
            state <= 1'b1; // Transition from A to B
        end else begin
            // Either stay in A (if x=0 and in A) or stay in B (if in B)
            state <= state;
        end
    end
end

endmodule