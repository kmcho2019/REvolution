module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1'b0) and state B (1'b1)

always @(*) begin
    // Combinational logic for output 'z'
    z = (state) ? ~x : x;
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        if (!state && x) begin
            state <= 1'b1; // Move to B when x=1 in state A
        end else if (state) begin
            state <= 1'b1; // Stay in B regardless of x
        end else begin
            state <= 1'b0; // Stay in A when x=0
        end
    end
end

endmodule