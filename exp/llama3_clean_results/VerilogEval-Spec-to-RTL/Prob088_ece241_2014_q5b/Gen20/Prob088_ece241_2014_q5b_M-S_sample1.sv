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
            1'b1: state <= ~x; // Transition to B if x=1, stay in A if x=0
            1'b0: state <= 1'b0; // Stay in B
        endcase
    end
end

assign z = (state)? x : ~x; // Directly generate 'z' based on state and 'x'

endmodule