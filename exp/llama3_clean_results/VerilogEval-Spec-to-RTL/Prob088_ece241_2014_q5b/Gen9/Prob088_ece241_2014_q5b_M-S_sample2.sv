module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

always @(*) begin
    z = (state)? ~x : x; // Simplified output generation
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        state <= (state || x); // Simplified state transition
    end
end

endmodule