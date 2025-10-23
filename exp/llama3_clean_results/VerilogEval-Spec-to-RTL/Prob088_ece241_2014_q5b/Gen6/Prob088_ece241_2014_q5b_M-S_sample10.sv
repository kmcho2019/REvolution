module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

always @(*) begin
    if(state) begin // State B
        z = ~x;
    end else begin // State A
        z = x;
    end
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        state <= (state || x); // Stay in B or transition from A to B
    end
end

endmodule