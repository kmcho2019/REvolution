module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State A (0) or State B (1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        if(!state && x) begin
            state <= 1'b1; // Transition from A to B
        end
    end
end

always @(*) begin
    if(state) begin
        z = ~x; // State B
    end else begin
        z = x; // State A
    end
end

endmodule