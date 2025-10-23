module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

assign z = state? ~x : x;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        if(!state && x) begin
            state <= 1'b1; // Transition to B if x=1 and in state A
        end
    end
end

endmodule