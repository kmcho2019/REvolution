module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
    end else begin
        case(state)
            1'b1: if(x) state <= 1'b0; // Transition from A to B
            1'b0: if(~x) state <= 1'b0; // Stay in B, no change needed
        endcase
    end
end

assign z = (state) ? x : ~x; // Simplified logic for 'z'

endmodule