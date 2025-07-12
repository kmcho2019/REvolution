module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1'b0) and state B (1'b1)

always @(*) begin
    // Combinational logic for output 'z'
    z = (state)? ~x : x;
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        if(state) begin
            // Stay in state B regardless of x
            state <= 1'b1;
        end else if (x) begin
            // Move to state B when x=1
            state <= 1'b1;
        end else begin
            // Stay in state A when x=0
            state <= 1'b0;
        end
    end
end

endmodule